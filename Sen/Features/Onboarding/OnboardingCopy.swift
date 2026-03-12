import Foundation

enum OnboardingCopy {
    enum Welcome {
        static let headline   = "Own Your Day"
        static let subhead    = "Effortlessly organize your schedule. Stay productive."
        static let next       = "Next"
    }

    enum Info {
        static let headline   = "What Makes\nSen Different"
        static let features: [(String, String)] = [
            ("mic.fill",       "Sen turns your voice into a structured day"),
            ("wand.and.stars", "AI places every task at the perfect time"),
            ("bell.fill",      "A gentle nudge when it's time to shift focus"),
        ]
        static let next       = "Next"
    }

    enum Auth {
        static let signUpHeadline  = "Get Started"
        static let signInHeadline  = "Welcome Back"
        static let emailPlaceholder = "Email address"
        static let passwordPlaceholder = "Password"
        static let passwordHint    = "Password (min 8 characters)"
        static let forgotPassword  = "Forgot password?"
        static let signUp          = "Create account"
        static let signIn          = "Sign in"
        static let appleButton     = "Continue with Apple"
        static let googleButton    = "Continue with Google"
        static let orDivider       = "or"
        static let toggleToSignIn  = "Already have an account? "
        static let toggleToSignUp  = "Don't have an account? "
        static let signInLink      = "Sign in"
        static let signUpLink      = "Sign up"
        static let legalPrefix     = "By continuing, you agree to our "
        static let terms           = "Terms of Service"
        static let legalMiddle     = " and "
        static let privacy         = "Privacy Policy"
        static let verifyHeadline  = "Verify your\nemail"
        static let verifySub       = "Enter the 6-digit code sent to"
        static let verifyButton    = "Verify email"
        static let resendButton    = "Didn't get a code? Resend"
        static let codeSent        = "Code sent!"
    }

    enum Profile {
        static let headline   = "What's your\nname?"
        static let placeholder = "Your name"
        static let next       = "Next"
    }

    enum Goals {
        static let headline   = "How Does\nYour Day Look?"
        static let subhead    = "Sen adapts to fit."
        static let options: [(String, String, String)] = [
            ("briefcase.fill",   "Work",    "Focus, meetings, reviews"),
            ("book.fill",        "Study",   "Lectures, deadlines, assignments"),
            ("figure.walk",      "Balance", "Work hard. Rest harder."),
        ]
        static let next       = "Next"
    }

    enum Notifications {
        static let headline   = "A gentle\nnudge."
        static let subhead    = "Notifications that actually help you stay in flow."
        static let enable     = "Enable notifications"
        static let skip       = "Maybe later"
        static let getStarted = "Get started >"
    }

    enum ChoosePartner {
        static let headline = "Choose Your Partner"
        static let next     = "Next"
    }
}
