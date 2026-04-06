# Flutter Wrapper
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Dart
-keepclasseswithmembernames class ** {
    native <methods>;
}

# Retrofit & Dio
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.gson.** { *; }
-keep interface com.google.gson.** { *; }
-keep class retrofit2.** { *; }
-keep interface retrofit2.** { *; }
-keep class io.k8s.** { *; }
-keep interface io.k8s.** { *; }

# Preserve generic signatures
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes SourceFile,LineNumberTable

# SQLite
-keep class androidx.sqlite.** { *; }

# Keep app components
-keep public class com.example.wms_app.** { *; }
