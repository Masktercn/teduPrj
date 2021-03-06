package cn.edu.gues.service;

import cn.edu.gues.mapper.IManyToManyMapper;
import org.springframework.beans.factory.annotation.Autowired;

import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.LinkedList;
import java.util.List;

/**
 * @author lulu
 */
public class ManyToManyBaseService<T,F,S> extends BaseService<T> {

    @Autowired
    private IManyToManyMapper<T,F,S> mapper;

    public int deleteByFirstId(Long firstId){
        if(firstId == null){
            throw new RuntimeException("firstId不能为null");
        }
        return mapper.deleteByFirstId(firstId);
    }

    public int deleteBySecondId(Long secondId){
        if(secondId == null){
            throw new RuntimeException("secondId不能为null");
        }
        return mapper.deleteBySecondId(secondId);
    }

    public List<F> selectFirstListBySecondId(Long secondId){
        if(secondId == null){
            throw new RuntimeException("secondId不能为空");
        }
        return mapper.selectFirstListBySecondId(secondId);
    }

    public F selectFirstOneBySecondId(Long secondId){
        if(secondId == null){
            throw new RuntimeException("secondId不能为null");
        }
        List<F> list = selectFirstListBySecondId(secondId);
        if(list != null && list.size() == 1){
            return list.get(0);
        }
        return null;
    }

    public List<S> selectSecondListByFirstId(Long firstId){
        if(firstId == null){
            throw new RuntimeException("firstId不能为空");
        }
        return mapper.selectSecondListByFirstId(firstId);
    }

    public S selectSecondOneByFirstId(Long firstId){
        if(firstId == null){
            throw new RuntimeException("firstId不能为null");
        }
        List<S> list = selectSecondListByFirstId(firstId);
        if(list != null && list.size() == 1){
            return list.get(0);
        }
        return null;
    }

    public void updateFirst(long firstId, Long[] secondIds) {
        try {
            ParameterizedType type = (ParameterizedType) getClass().getGenericSuperclass();
            //泛型类的Class对象
            Type[] genericTypes = type.getActualTypeArguments();

            Class tClass = (Class) genericTypes[0];//T
            Class fClass = (Class) genericTypes[1];//F
            Class sClass = (Class) genericTypes[2];//S

            //通过反射创建泛型T的对象
            T t = (T) tClass.newInstance();
            //获取并调用T的set(First)Id方法
            tClass.getDeclaredMethod("set" + fClass.getSimpleName() + "Id", Long.class).invoke(t, firstId);

            //查询旧的关联关系
            List<T> oldTList = selectList(t);

            //把数组中的数据转移到list中（方便下面的操作），并且把无效数据（secondId==null）剔除
            List<Long> secondIdList = new LinkedList<>();
            if (secondIds != null) {
                for (Long secondId : secondIds) {
                    if (secondId != null) {
                        secondIdList.add(secondId);
                    }
                }
            }

            //2 删掉原本在数据库中但现在不在secondIdList中的数据
            if (oldTList != null) {
                for (T tempT : oldTList) {
                    //拿到tempT对象的secondId
                    Long tempSecondId = (Long) tClass.getDeclaredMethod("get" + sClass.getSimpleName() + "Id")
                            .invoke(tempT);
                    if (!secondIdList.remove(tempSecondId)) {
                        delete((Long) tClass.getDeclaredMethod("getId").invoke(tempT));
                    }
                }
            }
            //3 把secondIdList中剩余的添加到数据库
            for (Long secondId : secondIdList) {
                tClass.getDeclaredMethod("set" + sClass.getSimpleName() + "Id", Long.class).invoke(t, secondId);
                insert(t);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @SuppressWarnings("all")
    public void updateSecond(long secondId, Long[] firstIds) {
        try {
            ParameterizedType type = (ParameterizedType) getClass().getGenericSuperclass();
            //泛型类的Class对象
            Type[] genericTypes = type.getActualTypeArguments();

            Class tClass = (Class) genericTypes[0];//T
            Class fClass = (Class) genericTypes[1];//F
            Class sClass = (Class) genericTypes[2];//S

            //通过反射创建泛型T的对象
            T t = (T) tClass.newInstance();
            //获取并调用T的set(Second)Id方法
            tClass.getDeclaredMethod("set" + sClass.getSimpleName() + "Id", Long.class).invoke(t, secondId);

            //查询旧的关联关系
            List<T> oldTList = selectList(t);

            //把数组中的数据转移到list中（方便下面的操作），并且把无效数据（firstId==null）剔除
            List<Long> firstIdList = new LinkedList<>();
            if (firstIds != null) {
                for (Long firstId : firstIds) {
                    if (firstId != null) {
                        firstIdList.add(firstId);
                    }
                }
            }

            //2 删掉原本在数据库中但现在不在firstIdList中的数据
            if (oldTList != null) {
                for (T tempT : oldTList) {
                    //拿到tempT对象的firstId
                    Long tempFirstId = (Long) tClass.getDeclaredMethod("get" + fClass.getSimpleName() + "Id")
                            .invoke(tempT);
                    if (!firstIdList.remove(tempFirstId)) {
                        delete((Long) tClass.getDeclaredMethod("getId").invoke(tempT));
                    }
                }
            }
            //3 把firstIdList中剩余的添加到数据库
            for (Long firstId : firstIdList) {
                tClass.getDeclaredMethod("set" + fClass.getSimpleName() + "Id", Long.class).invoke(t, secondId);
                insert(t);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}

