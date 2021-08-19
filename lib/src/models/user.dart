class User {
  final String name;
  final String email;
  final String? phone;
  final List<String>? subscriptions;
  final bool isAdmin;

  const User(
      {required this.name,
      required this.email,
      this.phone,
      this.subscriptions,
      required this.isAdmin});
}
