package com.example.biblio.resources;

/**
 * Interface that provides a general purpose event callback
 */
public interface EventCallback<T> {
    void trigger(T data);
}