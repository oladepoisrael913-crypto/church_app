// Top-level build file for Church App

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.0.2") // AGP
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.1.0") // Kotlin 2.1.0
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Move build output to the top-level Flutter build folder
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

// Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}