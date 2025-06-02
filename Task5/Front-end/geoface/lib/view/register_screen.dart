import 'package:attendee/view/login.dart';
import 'package:attendee/view/screens/student_dashboard.dart';
import 'package:flutter/material.dart';

class AdvancedRegisterScreen extends StatefulWidget {
  const AdvancedRegisterScreen({Key? key}) : super(key: key);

  @override
  State<AdvancedRegisterScreen> createState() => _AdvancedRegisterScreenState();
}

class _AdvancedRegisterScreenState extends State<AdvancedRegisterScreen>
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
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _matriculeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _termsAccepted = false;
  bool _isLoading = false;
  bool _showError = false;
  String _errorMessage = '';
  String _selectedRole = 'Student';
  double _passwordStrength = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _passwordController.addListener(() {
      _calculatePasswordStrength(_passwordController.text);
    });
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
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 2.0),
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
      curve: Curves.easeInOutCubic,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOutSine,
    ));

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 12.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 150), () {
      _slideController.forward();
    });
    _pulseController.repeat(reverse: true);
  }

  void _shakeForm() {
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });
  }

  void _calculatePasswordStrength(String password) {
    double strength = 0.0;
    if (password.length >= 8) strength += 0.25;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.25;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.25;
    setState(() {
      _passwordStrength = strength;
    });
  }

  Color _getStrengthColor() {
    if (_passwordStrength < 0.25) return Colors.redAccent;
    if (_passwordStrength < 0.5) return Colors.orangeAccent;
    if (_passwordStrength < 0.75) return Colors.yellowAccent;
    return Colors.greenAccent;
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    required String hint,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        onChanged: onChanged,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.black, fontSize: 16),
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

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      if (!_termsAccepted) {
        setState(() {
          _showError = true;
          _errorMessage = 'Please accept the Terms & Conditions';
        });
        _shakeForm();
        return;
      }

      setState(() {
        _isLoading = true;
        _showError = false;
      });

      // Simulate API call for registration
      await Future.delayed(const Duration(seconds: 2));

      // Simulate validation (e.g., email must contain 'university.edu')
      if (_emailController.text.contains('university.edu')) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration Successful! Proceed to Facial Setup.'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate to Facial Recognition Setup Screen
        Navigator.pushNamed(context, '/facial_setup');
      } else {
        setState(() {
          _isLoading = false;
          _showError = true;
          _errorMessage =
              'Please use a valid university email (e.g., name@university.edu)';
        });
        _shakeForm();
      }
    } else {
      setState(() {
        _showError = true;
        _errorMessage = 'Please correct the errors in the form';
      });
      _shakeForm();
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
                              Icons.person_add_rounded,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Join the University of Buea attendance system',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Animated Form
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
                                  controller: _nameController,
                                  icon: Icons.person_outline,
                                  label: 'Full Name',
                                  hint: 'Enter your full name',
                                  validator: (value) => value?.isEmpty == true
                                      ? 'Name is required'
                                      : null,
                                ),

                                _buildAnimatedTextField(
                                  controller: _emailController,
                                  icon: Icons.email_outlined,
                                  label: 'Email',
                                  hint: 'Enter your university email',
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
                                  controller: _matriculeController,
                                  icon: Icons.badge_outlined,
                                  label: 'Matricule/ID',
                                  hint: 'Enter your matricule/ID number',
                                  validator: (value) => value?.isEmpty == true
                                      ? 'Matricule/ID is required'
                                      : null,
                                ),

                                _buildAnimatedTextField(
                                  controller: _passwordController,
                                  icon: Icons.lock_outline,
                                  label: 'Password',
                                  hint: 'Enter your password',
                                  obscureText: _obscurePassword,
                                  onChanged: _calculatePasswordStrength,
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
                                  validator: (value) => (value?.length ?? 0) < 6
                                      ? 'Password must be 6+ characters'
                                      : null,
                                ),

                                // Password Strength Indicator
                                if (_passwordController.text.isNotEmpty)
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Password Strength: ${(_passwordStrength * 100).toInt()}%',
                                          style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12),
                                        ),
                                        const SizedBox(height: 5),
                                        LinearProgressIndicator(
                                          value: _passwordStrength,
                                          backgroundColor: Colors.white30,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  _getStrengthColor()),
                                        ),
                                      ],
                                    ),
                                  ),

                                _buildAnimatedTextField(
                                  controller: _confirmPasswordController,
                                  icon: Icons.lock_outline,
                                  label: 'Confirm Password',
                                  hint: 'Confirm your password',
                                  obscureText: _obscureConfirmPassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white70,
                                    ),
                                    onPressed: () => setState(() =>
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword),
                                  ),
                                  validator: (value) =>
                                      value != _passwordController.text
                                          ? 'Passwords do not match'
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

                                // Role Selection
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.2)),
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    value: _selectedRole,
                                    dropdownColor: const Color(0xFF2a5298),
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'Role',
                                      labelStyle: const TextStyle(
                                          color: Colors.white70),
                                      border: InputBorder.none,
                                      prefixIcon: Container(
                                        margin: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Colors.cyanAccent,
                                              Colors.blueAccent
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Icon(Icons.school_outlined,
                                            color: Colors.white, size: 20),
                                      ),
                                    ),
                                    items: ['Student', 'Educator'].map((role) {
                                      return DropdownMenuItem(
                                          value: role,
                                          child: Text(role,
                                              style: const TextStyle(
                                                  color: Colors.white)));
                                    }).toList(),
                                    onChanged: (value) =>
                                        setState(() => _selectedRole = value!),
                                    validator: (value) => value == null
                                        ? 'Please select a role'
                                        : null,
                                  ),
                                ),

                                // Terms Checkbox
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _termsAccepted,
                                      onChanged: (value) => setState(
                                          () => _termsAccepted = value!),
                                      activeColor: Colors.blueAccent,
                                    ),
                                    const Expanded(
                                      child: Text(
                                        'I accept the Terms & Conditions',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 30),

                                // Register Button
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
                                    // ?_isLoading ? null :
                                    //  _handleRegister,
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
                                              Text('Registering...',
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                            ],
                                          )
                                        : const Text(
                                            'Create Account',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                  ),
                                ),

                                const SizedBox(height: 30),

                                // Back to Login Link
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Already have an account? ',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AdvancedLoginScreen()));
                                      },
                                      child: const Text(
                                        'Sign In',
                                        style: TextStyle(
                                          color: Colors.blueAccent,
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
    _nameController.dispose();
    _emailController.dispose();
    _matriculeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
