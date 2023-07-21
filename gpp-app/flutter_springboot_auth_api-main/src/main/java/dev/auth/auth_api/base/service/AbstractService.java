package dev.auth.auth_api.base.service;

import dev.auth.auth_api.base.model.AbstractEntity;

import java.util.List;

public interface AbstractService<T extends AbstractEntity> {

    List<T> findAll();
    T findById(Long id);
    List<T> findAllEnabled();
    T save(T entity);
    List<T> saveAll(List<T> list);
    T update(T entity);
    T updateStatus(Long id);
    void delete(Long id);
}
