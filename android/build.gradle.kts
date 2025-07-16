// Top-level build file where you can add configuration options common to all sub-projects/modules.

// android/build.gradle.kts (Kotlin DSL)

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // ✅ Kotlin DSL uses "classpath(...)" function
        classpath("com.google.gms:google-services:4.3.15")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// tasks.register("clean", Delete::class) {
//     delete(rootProject.buildDir)
// }



val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
