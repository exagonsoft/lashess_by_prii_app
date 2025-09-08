# ============================
# ProGuard rules for Flutter
# ============================

# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Firebase
-keepattributes *Annotation*
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Play Services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Gson / JSON
-keep class com.google.gson.** { *; }
-keep class sun.misc.** { *; }
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn com.google.gson.**

# Kotlin Coroutines
-dontwarn kotlinx.coroutines.**

# Retrofit / OkHttp (if used in your app)
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep class okio.** { *; }

# Glide (if used for image loading)
-keep public class * implements com.bumptech.glide.module.GlideModule
-keep public class * extends com.bumptech.glide.AppGlideModule
-keep public enum com.bumptech.glide.load.ImageHeaderParser$** {
    **[] $VALUES;
    public *;
}
-dontwarn com.bumptech.glide.**

# Prevent warnings about Java 8+ APIs
-dontwarn java.lang.invoke.*
