import 'package:flutter/material.dart';

import 'register_screen.dart';
import 'screens/student_dashboard.dart';

class AdvancedLoginScreen extends StatefulWidget {
  const AdvancedLoginScreen({Key? key}) : super(key: key);

  @override
  State<AdvancedLoginScreen> createState() => _AdvancedLoginScreenState();
}

class _AdvancedLoginScreenState extends State<AdvancedLoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shakeAnimation;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  bool _showError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
    _pulseController.repeat(reverse: true);
  }

  void _shakeForm() {
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    required String hint,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.cyanAccent, Colors.blueAccent],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          suffixIcon: suffixIcon,
          labelStyle: const TextStyle(color: Colors.white70, fontSize: 14),
          hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButton(IconData icon, String label, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(icon, size: 20),
          label: Text(label, style: const TextStyle(fontSize: 12)),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            padding: const EdgeInsets.symmetric(vertical: 12),
            elevation: 5,
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _showError = false;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Simulate login validation
      if (_emailController.text == 'demo@university.edu' &&
          _passwordController.text == 'password123') {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Successful! Welcome back!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
          _showError = true;
          _errorMessage =
              'Invalid email or password. Try: demo@university.edu / password123';
        });
        _shakeForm();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 65, 96, 182),
              Color.fromARGB(255, 84, 196, 211),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // Animated Header
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        ScaleTransition(
                          scale: _pulseAnimation,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Colors.cyanAccent, Colors.blueAccent],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.cyanAccent.withOpacity(0.4),
                                  blurRadius: 25,
                                  spreadRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.school_rounded,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Sign in to continue to attendance system',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Animated Login Form
                  SlideTransition(
                    position: _slideAnimation,
                    child: AnimatedBuilder(
                      animation: _shakeAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(
                              _shakeAnimation.value *
                                  (_shakeController.status ==
                                          AnimationStatus.reverse
                                      ? -1
                                      : 1),
                              0),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 16, 62, 155),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.2)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                _buildAnimatedTextField(
                                  controller: _emailController,
                                  icon: Icons.email_outlined,
                                  label: 'Email',
                                  hint: 'Enter your email address',
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value?.isEmpty == true)
                                      return 'Email is required';
                                    if (!value!.contains('@'))
                                      return 'Please enter a valid email';
                                    return null;
                                  },
                                ),

                                _buildAnimatedTextField(
                                  controller: _passwordController,
                                  icon: Icons.lock_outline,
                                  label: 'Password',
                                  hint: 'Enter your password',
                                  obscureText: _obscurePassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white70,
                                    ),
                                    onPressed: () => setState(() =>
                                        _obscurePassword = !_obscurePassword),
                                  ),
                                  validator: (value) => (value?.length ?? 0) < 3
                                      ? 'Password is required'
                                      : null,
                                ),

                                // Error Message
                                if (_showError)
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.redAccent
                                              .withOpacity(0.5)),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.error_outline,
                                            color: Colors.redAccent, size: 20),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            _errorMessage,
                                            style: const TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                // Remember Me & Forgot Password
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _rememberMe,
                                          onChanged: (value) => setState(
                                              () => _rememberMe = value!),
                                          activeColor: Colors.cyanAccent,
                                        ),
                                        const Text(
                                          'Remember Me',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                            color: Colors.cyanAccent,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 30),

                                // Login Button
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: double.infinity,
                                  height: 55,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  StudentDashboardScreen()));
                                    },
                                    // _isLoading ? null : _handleLogin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      elevation: 15,
                                      shadowColor:
                                          Colors.cyanAccent.withOpacity(0.4),
                                    ),
                                    child: _isLoading
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                              ),
                                              SizedBox(width: 12),
                                              Text('Signing In...',
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                            ],
                                          )
                                        : const Text(
                                            'Sign In',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                  ),
                                ),

                                const SizedBox(height: 30),

                                // Divider
                                Row(
                                  children: [
                                    Expanded(
                                        child: Divider(
                                            color:
                                                Colors.white.withOpacity(0.3))),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: Text('OR',
                                          style:
                                              TextStyle(color: Colors.white70)),
                                    ),
                                    Expanded(
                                        child: Divider(
                                            color:
                                                Colors.white.withOpacity(0.3))),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                // Social Login Buttons
                                Row(
                                  children: [],
                                ),

                                const SizedBox(height: 30),

                                // Register Link
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Don't have an account? ",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AdvancedRegisterScreen()));
                                      },
                                      child: const Text(
                                        'Register Now',
                                        style: TextStyle(
                                          color: Colors.cyanAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    _shakeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
