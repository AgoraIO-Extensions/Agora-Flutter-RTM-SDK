-keepattributes *Annotation*
-keep class kotlin.** { *; }
-keep class org.jetbrains.** { *; }

-keep class io.agora.**{*;}
-dontwarn com.google.devtools.build.android.desugar.runtime.ThrowableExtension
