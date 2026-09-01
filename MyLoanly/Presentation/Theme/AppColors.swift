//
//  AppColors.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import SwiftUI

public enum AppColors {
    public static let navy = Color("Navy")
    public static let orange = Color("Orange")
    public static let yellow = Color("Yellow")
    public static let canvas = Color("Canvas")
    public static let surface = Color("Surface")
    public static let ink = Color("Ink")
    public static let muted = Color("Muted")
    public static let green = Color("Green")
}

// MARK: - Color Extension for Direct Access
public extension Color {
    static let appNavy = AppColors.navy
    static let appOrange = AppColors.orange
    static let appYellow = AppColors.yellow
    static let appCanvas = AppColors.canvas
    static let appSurface = AppColors.surface
    static let appInk = AppColors.ink
    static let appMuted = AppColors.muted
    static let appGreen = AppColors.green
}

