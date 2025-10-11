package com.amirmojiry.daily_quotes;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.widget.RemoteViews;
import org.json.JSONObject;
import org.json.JSONException;

/**
 * Daily Quotes Widget Provider
 * Displays inspirational quotes on the home screen
 */
public class DailyQuotesWidgetProvider extends AppWidgetProvider {

    private static final String PREFS_NAME = "daily_quotes_widget";
    private static final String PREF_QUOTE_KEY = "quote_";
    private static final String PREF_AUTHOR_KEY = "author_";
    private static final String PREF_THEME_KEY = "theme_";

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        // Update all widget instances
        for (int appWidgetId : appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId);
        }
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        super.onReceive(context, intent);
        
        // Handle widget data updates
        if (intent.getAction() != null && intent.getAction().equals("com.amirmojiry.daily_quotes.WIDGET_UPDATE")) {
            String widgetData = intent.getStringExtra("widget_data");
            if (widgetData != null) {
                updateWidgetData(context, widgetData);
            }
        }
    }

    private void updateWidgetData(Context context, String widgetData) {
        try {
            JSONObject data = new JSONObject(widgetData);
            String quote = data.optString("quote", "The only way to do great work is to love what you do.");
            String author = data.optString("author", "Steve Jobs");
            String theme = data.optString("theme", "dark");

            // Save to SharedPreferences
            SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
            SharedPreferences.Editor editor = prefs.edit();
            editor.putString(PREF_QUOTE_KEY, quote);
            editor.putString(PREF_AUTHOR_KEY, author);
            editor.putString(PREF_THEME_KEY, theme);
            editor.apply();

            // Update all widgets
            AppWidgetManager appWidgetManager = AppWidgetManager.getInstance(context);
            int[] appWidgetIds = appWidgetManager.getAppWidgetIds(
                new android.content.ComponentName(context, DailyQuotesWidgetProvider.class)
            );
            for (int appWidgetId : appWidgetIds) {
                updateAppWidget(context, appWidgetManager, appWidgetId);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    static void updateAppWidget(Context context, AppWidgetManager appWidgetManager, int appWidgetId) {
        // Get widget data from SharedPreferences
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        String quote = prefs.getString(PREF_QUOTE_KEY, "The only way to do great work is to love what you do.");
        String author = prefs.getString(PREF_AUTHOR_KEY, "Steve Jobs");
        String theme = prefs.getString(PREF_THEME_KEY, "dark");

        // Create RemoteViews
        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.daily_quotes_widget);

        // Set quote text
        views.setTextViewText(R.id.widget_quote, "\"" + quote + "\"");
        views.setTextViewText(R.id.widget_author, "— " + author);

        // Set theme-based colors
        if ("light".equals(theme)) {
            views.setTextColor(R.id.widget_quote, 0xFF213547); // Dark text for light theme
            views.setTextColor(R.id.widget_author, 0xFF213547);
            views.setInt(R.id.widget_layout, "setBackgroundColor", 0xFFFFFFFF); // White background
        } else {
            views.setTextColor(R.id.widget_quote, 0xFFFFFFFF); // Light text for dark theme
            views.setTextColor(R.id.widget_author, 0xFFFFFFFF);
            views.setInt(R.id.widget_layout, "setBackgroundColor", 0xFF242424); // Dark background
        }

        // Set click intent to open app
        Intent intent = new Intent(context, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(
            context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
        );
        views.setOnClickPendingIntent(R.id.widget_layout, pendingIntent);

        // Update the widget
        appWidgetManager.updateAppWidget(appWidgetId, views);
    }
}
