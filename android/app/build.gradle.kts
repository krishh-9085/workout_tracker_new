import com.android.build.gradle.internal.dsl.BaseAppModuleExtension
import java.util.Properties
import java.io.FileInputStream


plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // ✅ Firebase
}

android {
    namespace = "com.example.workout_tracker_new"
    compileSdk = 35
    ndkVersion = "27.0.12077973" // ✅ Fix NDK mismatch error

    defaultConfig {
        applicationId = "com.example.workout_tracker_new"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    signingConfigs {
    create("release") {
        val props = Properties().apply {
            load(FileInputStream(File(rootDir, "key.properties")))
        }

        storeFile = File(rootDir, props["storeFile"] as String)
        storePassword = props["storePassword"] as String
        keyAlias = props["keyAlias"] as String
        keyPassword = props["keyPassword"] as String
    }
}

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib:1.9.10")

    // ✅ Firebase BOM
    implementation(platform("com.google.firebase:firebase-bom:33.16.0"))

    // ✅ Firebase SDKs
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-analytics")
}

flutter {
    source = "../.."
}
