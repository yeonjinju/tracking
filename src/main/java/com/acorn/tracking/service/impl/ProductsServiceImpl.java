package com.acorn.tracking.service.impl;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.acorn.tracking.domain.Products;
import com.acorn.tracking.mapper.ProductsMapper;
import com.acorn.tracking.service.ProductsService;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ProductsServiceImpl implements ProductsService {

    private static final Logger logger = LoggerFactory.getLogger(ProductsServiceImpl.class);

    private final ProductsMapper productsMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void loadProductsFromFile() {
        try {
            InputStream inputStream = getProductsJsonInputStream();
            List<Products> products = readProductsFromJson(inputStream);
            insertProductsIntoDatabase(products);
        } catch (FileNotFoundException e) {
            handleFileNotFoundException(e);
        } catch (IOException e) {
            handleIOException(e);
        }
    }

    private InputStream getProductsJsonInputStream() throws FileNotFoundException {
        InputStream inputStream = getClass().getResourceAsStream("/static/Products.json");
        if (inputStream == null) {
            throw new FileNotFoundException("File not found: Products.json");
        }
        return inputStream;
    }

    private List<Products> readProductsFromJson(InputStream inputStream) throws IOException {
        return new GsonBuilder()
                .create().fromJson(
                        new InputStreamReader(inputStream),
                        new TypeToken<List<Products>>() {
                        }.getType());
    }

    private void insertProductsIntoDatabase(List<Products> products) {
        try {
            for (Products product : products) {
                productsMapper.autoInsertProducts(product);
            }
        } catch (DataAccessException e) {
            logger.error("An error occurred while inserting products into the database", e);
            throw new RuntimeException("An error occurred while inserting products into the database", e);
        }
    }

    private void handleFileNotFoundException(FileNotFoundException e) {
        logger.error("File not found: Products.json", e);
        throw new RuntimeException("File not found: Products.json", e);
    }

    private void handleIOException(IOException e) {
        logger.error("An error occurred while reading the products from the JSON file", e);
        throw new RuntimeException("An error occurred while reading the products from the JSON file", e);
    }
}