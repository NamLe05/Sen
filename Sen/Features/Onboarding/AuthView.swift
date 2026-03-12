import SwiftUI
import ClerkKit

@MainActor
struct AuthView: View {
    @Binding var path: NavigationPath
    @Environment(AuthManager.self) private var authManager
    @Environment(OnboardingSession.self) private var onboardingSession
    @Environment(Clerk.self) private var clerk

    enum AuthMode { case signUp, signIn }
    enum ScreenState { case form, verify }
    enum LoadingKind: Equatable { case apple, google, email }
    enum Field: Hashable { case email, password }

    @State private var mode: AuthMode = .signUp
    @State private var screenState: ScreenState = .form
    @State private var loading: LoadingKind?
    @State private var errorMessage = ""
    @State private var email = ""
    @State private var password = ""
    @State private var verifyCode = ""
    @State private var resendSuccess = false
    @FocusState private var focusedField: Field?
    @FocusState private var codeFieldFocused: Bool

    private var isEmailValid: Bool { email.contains("@") && email.contains(".") }
    private var isPasswordValid: Bool { password.count >= 8 }
    private var canSubmit: Bool { isEmailValid && (mode == .signIn || isPasswordValid) && loading == nil }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                topBar

                if screenState == .verify {
                    verifyContent
                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                } else {
                    formContent
                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                }
            }
            .padding(.horizontal, Spacing.lg)
            .animation(.easeOut(duration: 0.25), value: screenState)
        }
        .scrollDismissesKeyboard(.interactively)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgPrimary.ignoresSafeArea())
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Button {
                if screenState == .verify {
                    withAnimation { screenState = .form }
                } else {
                    path.removeLast()
                }
            } label: {
                Image(systemName: "arrow.left")
                    .font(.senHeadline)
                    .foregroundColor(.textInverse)
                    .frame(width: 44, height: 44)
                    .background(Color.textPrimary)
                    .clipShape(Circle())
            }
            .accessibilityLabel("Go back")

            Spacer()

            Image(systemName: "sparkles")
                .font(.senIconTitle)
                .foregroundColor(.accent)
                .frame(width: 44, height: 44)
        }
        .padding(.top, Spacing.md)
        .fadeSlideIn(delay: 0)
    }

    // MARK: - Form

    private var formContent: some View {
        VStack(alignment: .leading, spacing: Spacing.xl) {
            // Headline
            Text(mode == .signUp
                 ? OnboardingCopy.Auth.signUpHeadline
                 : OnboardingCopy.Auth.signInHeadline)
                .font(.senLargeTitle)
                .tracking(-0.5)
                .foregroundColor(.textPrimary)
                .padding(.top, Spacing.lg)
                .fadeSlideIn(delay: 0)

            // OAuth buttons
            VStack(spacing: Spacing.md) {
                oauthButton(
                    icon: "apple.logo",
                    label: OnboardingCopy.Auth.appleButton,
                    isLoading: loading == .apple,
                    style: .dark
                ) {
                    Task { await handleAppleSignIn() }
                }

                oauthButton(
                    icon: "globe",
                    label: OnboardingCopy.Auth.googleButton,
                    isLoading: loading == .google,
                    style: .light
                ) {
                    Task { await handleGoogleSignIn() }
                }

                divider
            }
            .fadeSlideIn(delay: 0.1)

            // Email + password fields
            VStack(spacing: Spacing.sm) {
                emailField
                passwordField

                if mode == .signIn {
                    Button(OnboardingCopy.Auth.forgotPassword) {}
                        .font(.senCaptionMedium)
                        .foregroundColor(.accent)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .fadeSlideIn(delay: 0.15)

            // Error
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.senCaption)
                    .foregroundColor(.senError)
                    .padding(.horizontal, Spacing.md)
                    .padding(.vertical, Spacing.sm)
                    .background(Color.errorBg)
                    .cornerRadius(Radius.sm)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }

            // Primary CTA
            primaryButton(
                label: mode == .signUp ? OnboardingCopy.Auth.signUp : OnboardingCopy.Auth.signIn,
                isLoading: loading == .email,
                disabled: !canSubmit
            ) {
                Task { await handleEmailAuth() }
            }
            .fadeSlideIn(delay: 0.2)

            // Mode toggle
            HStack {
                Spacer()
                Text(mode == .signUp
                     ? OnboardingCopy.Auth.toggleToSignIn
                     : OnboardingCopy.Auth.toggleToSignUp)
                    .font(.senLabel)
                    .foregroundColor(.textMuted)

                Button(mode == .signUp
                       ? OnboardingCopy.Auth.signInLink
                       : OnboardingCopy.Auth.signUpLink) {
                    withAnimation(.easeOut(duration: 0.2)) {
                        mode = mode == .signUp ? .signIn : .signUp
                        errorMessage = ""
                        password = ""
                    }
                }
                .font(.senLabelBold)
                .foregroundColor(.accent)
                Spacer()
            }
            .fadeSlideIn(delay: 0.25)

            // Legal (sign-up only)
            if mode == .signUp {
                legalText
                    .fadeSlideIn(delay: 0.3)
            }

            Spacer(minLength: Spacing.xxl)
        }
    }

    // MARK: - Verify

    private var verifyContent: some View {
        VStack(alignment: .leading, spacing: Spacing.xl) {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text(OnboardingCopy.Auth.verifyHeadline)
                    .font(.senLargeTitle)
                    .tracking(-0.5)
                    .foregroundColor(.textPrimary)
                    .padding(.top, Spacing.lg)

                Text("\(OnboardingCopy.Auth.verifySub) \(email)")
                    .font(.senFootnote)
                    .foregroundColor(.textSecondary)
            }
            .fadeSlideIn(delay: 0)

            // Code boxes
            codeBoxes
                .fadeSlideIn(delay: 0.1)

            // Error
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.senCaption)
                    .foregroundColor(.senError)
                    .padding(.horizontal, Spacing.md)
                    .padding(.vertical, Spacing.sm)
                    .background(Color.errorBg)
                    .cornerRadius(Radius.sm)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }

            primaryButton(
                label: OnboardingCopy.Auth.verifyButton,
                isLoading: loading == .email,
                disabled: verifyCode.count < 6 || loading != nil
            ) {
                Task { await handleVerify() }
            }
            .fadeSlideIn(delay: 0.15)

            HStack {
                Spacer()
                if resendSuccess {
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.success)
                        Text(OnboardingCopy.Auth.codeSent)
                            .font(.senCaptionBold)
                            .foregroundColor(.success)
                    }
                    .transition(.opacity)
                } else {
                    Button(OnboardingCopy.Auth.resendButton) {
                        Task { await handleResend() }
                    }
                    .font(.senCaption)
                    .foregroundColor(.accent)
                }
                Spacer()
            }
            .animation(.easeOut(duration: 0.2), value: resendSuccess)
            .fadeSlideIn(delay: 0.2)

            Spacer(minLength: Spacing.xxl)
        }
    }

    // MARK: - Sub-components

    private var emailField: some View {
        TextField(OnboardingCopy.Auth.emailPlaceholder, text: $email)
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .textContentType(.emailAddress)
            .submitLabel(.next)
            .focused($focusedField, equals: .email)
            .onSubmit { focusedField = .password }
            .padding(.horizontal, Spacing.md)
            .frame(height: 52)
            .background(Color.bgSecondary)
            .cornerRadius(Radius.md)
    }

    private var passwordField: some View {
        SecureField(
            mode == .signUp
                ? OnboardingCopy.Auth.passwordHint
                : OnboardingCopy.Auth.passwordPlaceholder,
            text: $password
        )
        .textContentType(mode == .signUp ? .newPassword : .password)
        .submitLabel(.done)
        .focused($focusedField, equals: .password)
        .onSubmit {
            if canSubmit { Task { await handleEmailAuth() } }
        }
        .padding(.horizontal, Spacing.md)
        .frame(height: 52)
        .background(Color.bgSecondary)
        .cornerRadius(Radius.md)
    }

    private var divider: some View {
        HStack(spacing: Spacing.sm) {
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(.border)
            Text(OnboardingCopy.Auth.orDivider)
                .font(.senCaption)
                .foregroundColor(.textMuted)
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(.border)
        }
        .padding(.vertical, Spacing.xs)
    }

    private var legalText: some View {
        (Text(OnboardingCopy.Auth.legalPrefix)
            + Text(OnboardingCopy.Auth.terms).foregroundColor(.accent)
            + Text(OnboardingCopy.Auth.legalMiddle)
            + Text(OnboardingCopy.Auth.privacy).foregroundColor(.accent))
            .font(.senLegal)
            .foregroundColor(.textMuted)
            .multilineTextAlignment(.center)
            .tracking(0.2)
            .frame(maxWidth: .infinity)
    }

    private var codeBoxes: some View {
        ZStack {
            // Hidden input field
            TextField("", text: $verifyCode)
                .keyboardType(.numberPad)
                .focused($codeFieldFocused)
                .frame(width: 1, height: 1)
                .opacity(0)
                .onChange(of: verifyCode) { _, new in
                    let filtered = String(new.filter { $0.isNumber }.prefix(6))
                    if filtered != new { verifyCode = filtered }
                }

            // Visual boxes
            HStack(spacing: Spacing.sm) {
                ForEach(0..<6, id: \.self) { index in
                    codeBox(at: index)
                }
            }
        }
        .onTapGesture { codeFieldFocused = true }
        .onAppear { codeFieldFocused = true }
    }

    private func codeBox(at index: Int) -> some View {
        let digit: String = index < verifyCode.count
            ? String(verifyCode[verifyCode.index(verifyCode.startIndex, offsetBy: index)])
            : ""
        let isFilled = index < verifyCode.count
        let isActive = codeFieldFocused && index == verifyCode.count

        return Text(digit)
            .font(.senTitle)
            .foregroundColor(.textPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(isFilled ? Color.bgTertiary : Color.bgSecondary)
            .cornerRadius(Radius.md)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.md)
                    .stroke(isActive ? Color.accent : Color.clear, lineWidth: 1.5)
            )
            .animation(.easeOut(duration: 0.15), value: isFilled)
    }

    // MARK: - Buttons

    @ViewBuilder
    private func oauthButton(
        icon: String,
        label: String,
        isLoading: Bool,
        style: OAuthStyle,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: Spacing.sm) {
                if isLoading {
                    ProgressView()
                        .tint(style == .dark ? .white : .textPrimary)
                } else {
                    Image(systemName: icon)
                        .font(.senHeadline)
                        .foregroundColor(style == .dark ? .textInverse : .textPrimary)
                    Text(label)
                        .font(.senSubheadline)
                        .foregroundColor(style == .dark ? .textInverse : .textPrimary)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(style == .dark ? Color.textPrimary : Color.bgPrimary)
            .cornerRadius(Radius.md)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.md)
                    .stroke(style == .dark ? Color.clear : Color.border, lineWidth: 1.5)
            )
        }
        .disabled(loading != nil)
        .buttonStyle(PressOpacityStyle())
        .accessibilityLabel(label)
    }

    @ViewBuilder
    private func primaryButton(
        label: String,
        isLoading: Bool,
        disabled: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Group {
                if isLoading {
                    ProgressView().tint(.textInverse)
                } else {
                    Text(label)
                        .font(.senHeadline)
                        .foregroundColor(.textInverse)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color.accent.opacity(disabled ? 0.5 : 1))
            .cornerRadius(Radius.md)
        }
        .disabled(disabled)
        .buttonStyle(PressOpacityStyle())
        .accessibilityLabel(label)
    }

    enum OAuthStyle { case dark, light }

    // MARK: - Auth Actions

    private func handleEmailAuth() async {
        guard canSubmit else { return }
        focusedField = nil
        withAnimation { errorMessage = "" }
        loading = .email

        do {
            if mode == .signUp {
                let signUp = try await clerk.auth.signUp(emailAddress: email, password: password)
                try await signUp.sendEmailCode()
                withAnimation { screenState = .verify }
            } else {
                try await clerk.auth.signInWithPassword(identifier: email, password: password)
                await completeSignIn(isNewUser: false)
            }
        } catch {
            withAnimation { errorMessage = error.localizedDescription }
        }

        loading = nil
    }

    private func handleVerify() async {
        guard verifyCode.count == 6 else { return }
        withAnimation { errorMessage = "" }
        loading = .email

        do {
            guard let signUp = clerk.client?.signUp else {
                withAnimation { errorMessage = "Sign-up session expired. Please try again." }
                loading = nil
                return
            }
            try await signUp.verifyEmailCode(verifyCode)
            await completeSignIn(isNewUser: true)
        } catch {
            withAnimation { errorMessage = error.localizedDescription }
        }

        loading = nil
    }

    private func handleResend() async {
        do {
            guard let signUp = clerk.client?.signUp else { return }
            try await signUp.sendEmailCode()
            withAnimation { resendSuccess = true }
            try? await Task.sleep(for: .seconds(3))
            withAnimation { resendSuccess = false }
        } catch {
            withAnimation { errorMessage = error.localizedDescription }
        }
    }

    private func handleAppleSignIn() async {
        loading = .apple
        do {
            let result = try await clerk.auth.signInWithApple()
            if case .signUp = result { await completeSignIn(isNewUser: true) }
            else { await completeSignIn(isNewUser: false) }
        } catch {
            withAnimation { errorMessage = error.localizedDescription }
        }
        loading = nil
    }

    private func handleGoogleSignIn() async {
        loading = .google
        do {
            let result = try await clerk.auth.signInWithOAuth(provider: .google)
            if case .signUp = result { await completeSignIn(isNewUser: true) }
            else { await completeSignIn(isNewUser: false) }
        } catch {
            withAnimation { errorMessage = error.localizedDescription }
        }
        loading = nil
    }

    /// Called after successful auth.
    /// New users: stash credentials in OnboardingSession and continue setup screens.
    /// Returning users: sign in immediately — ContentView auto-switches to main app.
    private func completeSignIn(isNewUser: Bool) async {
        do {
            guard let clerkSession = clerk.session else {
                withAnimation { errorMessage = "No active session" }
                return
            }

            guard let jwt = try await clerkSession.getToken() else {
                withAnimation { errorMessage = "Failed to get session token" }
                return
            }

            let userId = clerk.user?.id ?? ""

            if isNewUser {
                onboardingSession.pendingToken = jwt
                onboardingSession.pendingClerkId = userId
                path.append(OnboardingRoute.profileSetup)
            } else {
                await authManager.signIn(token: jwt, clerkId: userId)
            }
        } catch {
            withAnimation { errorMessage = error.localizedDescription }
        }
    }
}
