package app.munch.facebookappevents;

import android.os.Bundle;
import com.facebook.appevents.AppEventsLogger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import java.util.Map;

/**
 * FacebookAppEventsPlugin
 */
public class FacebookAppEventsPlugin implements MethodCallHandler {

    private final AppEventsLogger logger;

    public FacebookAppEventsPlugin(Registrar registrar) {
        this.logger = AppEventsLogger.newLogger(registrar.activity());
    }

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "facebook_app_events");
        channel.setMethodCallHandler(new FacebookAppEventsPlugin(registrar));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case "logEvent":
                handleLogEvent(call, result);
                break;
            case "setUserId":
                handleSetUserId(call, result);
                break;
            case "clearUserId"
                handleClearUserId(call, result);
                break;
            case "clearUserData":
                handleClearUserData(call, result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void handleLogEvent(MethodCall call, Result result) {
        @SuppressWarnings("unchecked")
        Map<String, Object> arguments = (Map<String, Object>) call.arguments;
        final String eventName = (String) arguments.get("name");

        @SuppressWarnings("unchecked") final Bundle parameterBundle =
                createBundleFromMap((Map<String, Object>) arguments.get("parameters"));
        logger.logEvent(eventName, parameterBundle);
        result.success(null);
    }

    private void handleSetUserId(MethodCall call, Result result) {
        final String id = (String) call.arguments;
        AppEventsLogger.setUserID(id);
        result.success(null);
    }

    private void handleClearUserId(MethodCall call, Result result) {
        AppEventsLogger.clearUserId();
        result.success(null);
    }

    private void handleClearUserData(MethodCall call, Result result) {
        AppEventsLogger.clearUserData();
        result.success(null);
    }

    private static Bundle createBundleFromMap(Map<String, Object> map) {
        if (map == null) {
            return null;
        }

        Bundle bundle = new Bundle();
        for (Map.Entry<String, Object> jsonParam : map.entrySet()) {
            final Object value = jsonParam.getValue();
            final String key = jsonParam.getKey();
            if (value instanceof String) {
                bundle.putString(key, (String) value);
            } else if (value instanceof Integer) {
                bundle.putInt(key, (Integer) value);
            } else if (value instanceof Long) {
                bundle.putLong(key, (Long) value);
            } else if (value instanceof Double) {
                bundle.putDouble(key, (Double) value);
            } else if (value instanceof Boolean) {
                bundle.putBoolean(key, (Boolean) value);
            } else {
                throw new IllegalArgumentException(
                        "Unsupported value type: " + value.getClass().getCanonicalName());
            }
        }
        return bundle;
    }
}
