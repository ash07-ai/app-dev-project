import '../models/user.dart';

class MockUsers {
  static final List<User> users = [
    User(
      id: '1',
      name: 'John Doe',
      email: 'john@example.com',
      profileImage: 'https://picsum.photos/200/300?random=10',
      isAdmin: false,
      phoneNumber: '+1234567890',
      address: '123 Main St, City, Country',
    ),
    User(
      id: '2',
      name: 'Admin User',
      email: 'admin@example.com',
      profileImage: 'https://picsum.photos/200/300?random=11',
      isAdmin: true,
      phoneNumber: '+0987654321',
      address: '456 Admin St, City, Country',
    ),
  ];
}