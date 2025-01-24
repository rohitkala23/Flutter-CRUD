import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transaction_management_ui/screens/login_screen.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

void main() {
  Get.put<Dio>(Dio(BaseOptions(
    baseUrl: 'https://transaction-management-system-beta.vercel.app/',
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Content-Type': 'application/json'},
  )));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Transaction Management System',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            fontFamily: 'Roboto',
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          home: LoginScreen(),
        );
      },
    );
  }
}
