package io.flutter.plugins;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry;

/**
 * Generated file. Do not edit.
 * This file is generated by the Flutter tool based on the
 * plugins that support the Android platform.
 */
@Keep
public final class GeneratedPluginRegistrant {
  public static void registerWith(@NonNull FlutterEngine flutterEngine) {
    ShimPluginRegistry shimPluginRegistry = new ShimPluginRegistry(flutterEngine);
      dk.cachet.esense_flutter.EsenseFlutterPlugin.registerWith(shimPluginRegistry.registrarFor("dk.cachet.esense_flutter.EsenseFlutterPlugin"));
      com.ryanheise.just_audio.JustAudioPlugin.registerWith(shimPluginRegistry.registrarFor("com.ryanheise.just_audio.JustAudioPlugin"));
    flutterEngine.getPlugins().add(new io.flutter.plugins.pathprovider.PathProviderPlugin());
      com.ethras.simplepermissions.SimplePermissionsPlugin.registerWith(shimPluginRegistry.registrarFor("com.ethras.simplepermissions.SimplePermissionsPlugin"));
  }
}
