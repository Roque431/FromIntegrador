# ProGuard rules for LexIA App
# MSTG-CODE-1 compliance - Code Obfuscation and Protection

# Keep Flutter engine classes
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class androidx.lifecycle.DefaultLifecycleObserver

# Keep Firebase classes
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Keep Google Sign-In classes
-keep class com.google.android.gms.auth.** { *; }
-keep class com.google.android.gms.common.** { *; }

# Keep SecureStorage classes
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Keep location services
-keep class com.baseflow.geolocator.** { *; }

# Keep HTTP client classes
-keep class okhttp3.** { *; }
-keep class retrofit2.** { *; }

# Keep JSON serialization classes (if using)
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# Dart/Flutter specific optimizations
-dontwarn io.flutter.**
-dontwarn javax.annotation.**
-dontwarn org.conscrypt.**

# Security measures - Remove debug info in release
-repackageclasses
-allowaccessmodification
-mergeinterfacesaggressively

# Keep essential app classes (customize based on your needs)
-keep class com.example.flutter_application_1.** { *; }

# Remove logging in release builds
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
    public static *** w(...);
    public static *** e(...);
}

# Optimize and obfuscate
-optimizationpasses 5
-overloadaggressively
-repackageclasses ''
-allowaccessmodification

# Additional security measures
-printusage unused.txt
-printmapping mapping.txt