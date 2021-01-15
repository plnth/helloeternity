// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// Delete
  internal static let apodDelete = L10n.tr("Localizable", "apod_delete")
  /// Save
  internal static let apodSave = L10n.tr("Localizable", "apod_save")
  /// Save HD image to gallery
  internal static let apodSaveHDImage = L10n.tr("Localizable", "apod_save_HD_image")
  /// Please try again later
  internal static let apodSearchErrorMessage = L10n.tr("Localizable", "apod_search_error_message")
  /// OK
  internal static let apodSearchErrorOk = L10n.tr("Localizable", "apod_search_error_ok")
  /// Sorry, there was an error
  internal static let apodSearchErrorTitle = L10n.tr("Localizable", "apod_search_error_title")
  /// Search by date
  internal static let apodSearchPlaceholder = L10n.tr("Localizable", "apod_search_placeholder")
  /// Saved
  internal static let apodTabSaved = L10n.tr("Localizable", "apod_tab_saved")
  /// Today
  internal static let apodTabToday = L10n.tr("Localizable", "apod_tab_today")
  /// Cancel
  internal static let cancel = L10n.tr("Localizable", "cancel")
  /// Done
  internal static let done = L10n.tr("Localizable", "done")
  /// NASA Astronomy Picture of the Day
  internal static let mainMenuApod = L10n.tr("Localizable", "main_menu_Apod")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    Bundle(for: BundleToken.self)
  }()
}
// swiftlint:enable convenience_type
