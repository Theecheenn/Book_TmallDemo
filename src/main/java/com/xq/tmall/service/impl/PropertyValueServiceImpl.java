package com.xq.tmall.service.impl;

import com.xq.tmall.dao.PropertyValueMapper;
import com.xq.tmall.entity.PropertyValue;
import com.xq.tmall.service.PropertyValueService;
import com.xq.tmall.util.PageUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class PropertyValueServiceImpl implements PropertyValueService {
    @Autowired
    private PropertyValueMapper propertyValueMapper;


    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    @Override
    public boolean add(PropertyValue propertyValue) {
        return propertyValueMapper.insertOne(propertyValue) > 0;
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    @Override
    public boolean addList(List<PropertyValue> propertyValueList) {
        return propertyValueMapper.insertList(propertyValueList) > 0;
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    @Override
    public boolean update(PropertyValue propertyValue) {
        return propertyValueMapper.updateOne(propertyValue) > 0;
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    @Override
    public boolean deleteList(Integer[] propertyValue_id_list) {
        return propertyValueMapper.deleteList(propertyValue_id_list) > 0;
    }
    @Override
    public boolean delete(Integer id) {
        return propertyValueMapper.deleteOne(id) > 0;
    }
    @Override
    public List<PropertyValue> getList(PropertyValue propertyValue, PageUtil pageUtil) {
        return propertyValueMapper.select(propertyValue, pageUtil);
    }

    @Override
    public PropertyValue get(Integer propertyValue_id) {
        return propertyValueMapper.selectOne(propertyValue_id);
    }

    @Override
    public Integer getTotal(PropertyValue propertyValue) {
        return propertyValueMapper.selectTotal(propertyValue);
    }
}
