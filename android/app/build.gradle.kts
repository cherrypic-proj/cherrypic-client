import java.util.Properties
import java.io.FileInputStream

// .env 파일 읽어오기
val dotEnvFile = File(rootDir.parentFile, ".env")
val properties = Properties().apply {
    if (dotEnvFile.exists()) {
        load(FileInputStream(dotEnvFile))
    }
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.cherrypic"
    compileSdk = flutter.compileSdkVersion
//    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "today.cherrypic.android"
        minSdk = 21
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // .env 값 가져오기
        val kakaoAppKey = properties.getProperty("KAKAO_NATIVE_APP_KEY") ?: ""

        // manifestPlaceholders 로 넘겨줌
        manifestPlaceholders["kakao_app_key"] = "kakao$kakaoAppKey"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}