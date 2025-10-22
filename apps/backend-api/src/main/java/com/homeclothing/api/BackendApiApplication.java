package com.homeclothing.api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;

@SpringBootApplication
public class BackendApiApplication {
    public static void main(String[] args) {
        ConfigurableApplicationContext run;
        SpringApplication.run(BackendApiApplication.class, args);
    }
}
