package com.acorn.tracking.service.impl;

import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.acorn.tracking.domain.Orders;
import com.acorn.tracking.domain.Products;
import com.acorn.tracking.mapper.OrdersMapper;
import com.acorn.tracking.mapper.ProductsMapper;
import com.acorn.tracking.service.DeliveriesService;
import com.acorn.tracking.service.OrdersService;
import com.github.javafaker.Faker;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class OrdersServiceImpl implements OrdersService {

    private static final Logger logger = LoggerFactory.getLogger(OrdersServiceImpl.class);

    private final OrdersMapper ordersMapper;
    private final ProductsMapper productsMapper;
    private final DeliveriesService deliveriesService;

    @Override
    @Scheduled(initialDelay = 5000, fixedRate = 10000)
    public void autoInsertOrders() {
        try {
            Faker faker = new Faker(new Locale("ko"));
            Products.ProductInfo productInfo = productsMapper.getRandomProductsInfo(faker.random().nextInt(1, 5));
            InputStream inputStream = getOrdersJsonInputStream();
            List<Orders.OrderInfo> jsonOrderInfos = readOrdersFromJson(inputStream);
            Orders.OrderInfo orderInfo = jsonOrderInfos.get(faker.random().nextInt(jsonOrderInfos.size()));
            List<Integer> productIds = getProductIds(productInfo);
            Orders orders = createOrder(productInfo, productIds.size(), orderInfo);
            insertOrders(orders, productIds);
            autoInsertDelivery();
        } catch (FileNotFoundException e) {
            handleFileNotFoundException(e);
        }
    }

    private List<Integer> getProductIds(Products.ProductInfo productInfo) {
        return Arrays.stream(productInfo.getProduct_id().split(","))
                .map(Integer::parseInt)
                .collect(Collectors.toList());
    }

    private InputStream getOrdersJsonInputStream() throws FileNotFoundException {
        InputStream inputStream = getClass().getResourceAsStream("/static/Orders.json");
        if (inputStream == null) {
            throw new FileNotFoundException("File not found: Orders.json");
        }
        return inputStream;
    }

    private List<Orders.OrderInfo> readOrdersFromJson(InputStream inputStream) {
        return new GsonBuilder()
                .create().fromJson(
                        new InputStreamReader(inputStream),
                        new TypeToken<List<Orders.OrderInfo>>() {
                        }.getType());
    }

    private Orders createOrder(Products.ProductInfo productInfo, int quantity,
            Orders.OrderInfo orderInfo) {
        return Orders.builder()
                .quantity_ordered(quantity)
                .total_price(productInfo.getTotal_price())
                .latitude(orderInfo.getLatitude())
                .longitude(orderInfo.getLongitude())
                .customer_name(orderInfo.getCustomer_name())
                .build();
    }

    @Transactional
    private void insertOrders(Orders orders, List<Integer> productIds) {
        try {
            ordersMapper.autoInsertOrders(orders);
            for (Integer product_id : productIds) {
                productsMapper.inventoryReduction(product_id, 1);
            }
        } catch (Exception e) {
            handleInsertionException(e);
        }
    }

    private void autoInsertDelivery() {
        deliveriesService.autoInsertDelivery(ordersMapper.getLastInsertedOrderId());
    }

    private void handleFileNotFoundException(FileNotFoundException e) {
        logger.error("File not found: Orders.json", e);
    }

    private void handleInsertionException(Exception e) {
        logger.error("An error occurred while inserting orders", e);
    }
}
