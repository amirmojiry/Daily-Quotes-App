# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Capacitor specific rules
-keep class com.capacitorjs.** { *; }
-keep class com.getcapacitor.** { *; }
-keep class com.getcapacitor.plugin.** { *; }

# Keep JavaScript interfaces
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Keep WebView JavaScript interfaces
-keepclassmembers class fqcn.of.javascript.interface.for.webview {
    public *;
}

# Preserve line number information for debugging stack traces
-keepattributes SourceFile,LineNumberTable

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Capacitor plugins
-keep class com.getcapacitor.plugin.** { *; }
-keep class com.capacitorjs.plugins.** { *; }

# Keep Android WebView
-keep class android.webkit.** { *; }

# Keep JSON classes (if used)
-keep class org.json.** { *; }

# Keep reflection-based classes
-keepattributes Signature
-keepattributes *Annotation*

# Keep classes that might be accessed via reflection
-keep class * extends java.lang.Exception

# Keep all public classes and methods in the main package
-keep public class com.amirmojiry.daily_quotes.** { public *; }

# Keep all classes that might be instantiated via reflection
-keep class * implements java.io.Serializable { *; }

# Keep all enum classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Parcelable classes
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep all native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep JavaScript bridge methods
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
