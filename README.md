# 北航教务小助手前端
## 使用说明

第一步，安装Android Studio和Flutter sdk，具体教程参考https://flutterchina.club/get-started/install/。

第二步，配好环境后，将项目clone到本地。

```bash
git clone git@github.com:SE2020-TopUnderstanding/BUAA-Campus-Tools-Frontend.git
```

并将文件名改成`jiaowu_assistent`。

第三步，打开Android Studio，点击`Open an existing Android Studio project`，选择下载下来的文件夹。Android Studio会自动下载Android sdk，可能需要连接VPN。

第四步，在Android Studio内安装虚拟机，编译运行项目即可。

## 更新日志

#### 1.0.1

修复了选择完主页后点击确认，不会退回到上一级的bug。

#### 1.0.2

1. 使用了加密算法，更安全；
2. 有了更完善的错误处理机制。

#### 1.0.3

1. 优化了检测版本更新功能；
2. 在帮助中心添加了版本号的显示。

#### 1.0.4

成绩查询中添加夏季的成绩的查询。

#### 1.0.5

1. 课程中心DDL支持手动选择不显示”已完成“的作业项；
2. 修复了部分19级同学的DDL爬取的bug，之前因为DDL部分的bug，导致许多同学的DDL没有更新，或者新用户没有爬到DDL数据，在这里向大家致歉！