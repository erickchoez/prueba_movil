import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yiga Móvil',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class WorkOrder {
  final String orderNumber;
  final String client;
  final String phone;
  final String address;
  final String reference;
  final String workType;
  final String scheduledDate;
  final String timeSlot;
  String status;
  String? observation;
  String? photoPath;

  WorkOrder({
    required this.orderNumber,
    required this.client,
    required this.phone,
    required this.address,
    required this.reference,
    required this.workType,
    required this.scheduledDate,
    required this.timeSlot,
    required this.status,
    this.observation,
    this.photoPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderNumber': orderNumber,
      'client': client,
      'phone': phone,
      'address': address,
      'reference': reference,
      'workType': workType,
      'scheduledDate': scheduledDate,
      'timeSlot': timeSlot,
      'status': status,
      'observation': observation,
      'photoPath': photoPath,
    };
  }

  factory WorkOrder.fromJson(Map<String, dynamic> json) {
    return WorkOrder(
      orderNumber: json['orderNumber'],
      client: json['client'],
      phone: json['phone'],
      address: json['address'],
      reference: json['reference'],
      workType: json['workType'],
      scheduledDate: json['scheduledDate'],
      timeSlot: json['timeSlot'],
      status: json['status'],
      observation: json['observation'],
      photoPath: json['photoPath'],
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OrdersListScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su correo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su contraseña';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Ingresar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({super.key});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  List<WorkOrder> _orders = [];
  String _selectedFilter = 'Todos';

  final List<WorkOrder> _mockOrders = [
    WorkOrder(
      orderNumber: 'ORD-001',
      client: 'Juan Pérez',
      phone: '0909090901',
      address: 'Calle Principal',
      reference: 'Frente al parque',
      workType: 'Instalación de internet',
      scheduledDate: '2026-06-25',
      timeSlot: '09:00-11:00',
      status: 'Pendiente',
    ),
    WorkOrder(
      orderNumber: 'ORD-002',
      client: 'María García',
      phone: '0909090902',
      address: 'Av. Secundaria',
      reference: 'Casa azul',
      workType: 'Mantenimiento',
      scheduledDate: '2026-06-26',
      timeSlot: '14:00-16:00',
      status: 'En camino',
    ),
    WorkOrder(
      orderNumber: 'ORD-003',
      client: 'Carlos López',
      phone: '0909090903',
      address: 'Calle Tercera',
      reference: 'Edificio principal',
      workType: 'Reparación',
      scheduledDate: '2026-06-24',
      timeSlot: '10:00-12:00',
      status: 'Finalizada',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = prefs.getString('orders');
    if (ordersJson != null) {
      final List<dynamic> decoded = json.decode(ordersJson);
      setState(() {
        _orders = decoded.map((json) => WorkOrder.fromJson(json)).toList();
      });
    } else {
      setState(() {
        _orders = _mockOrders;
      });
      _saveOrders();
    }
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = json.encode(_orders.map((order) => order.toJson()).toList());
    await prefs.setString('orders', ordersJson);
  }

  List<WorkOrder> get _filteredOrders {
    if (_selectedFilter == 'Todos') {
      return _orders;
    }
    return _orders.where((order) => order.status == _selectedFilter).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pendiente':
        return Colors.orange;
      case 'En camino':
        return Colors.blue;
      case 'En sitio':
        return Colors.purple;
      case 'Finalizada':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Órdenes de Trabajo'),
        actions: [
          PopupMenuButton<String>(
            initialValue: _selectedFilter,
            onSelected: (String value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return ['Todos', 'Pendiente', 'En camino', 'En sitio', 'Finalizada']
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _filteredOrders.length,
        itemBuilder: (context, index) {
          final order = _filteredOrders[index];
          return Card(
            child: ListTile(
              title: Text('${order.orderNumber} - ${order.client}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.address),
                  Text(order.scheduledDate),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  order.status,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailScreen(
                      order: order,
                      onOrderUpdated: (updatedOrder) {
                        setState(() {
                          final index = _orders.indexWhere((o) => o.orderNumber == updatedOrder.orderNumber);
                          if (index != -1) {
                            _orders[index] = updatedOrder;
                          }
                        });
                        _saveOrders();
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class OrderDetailScreen extends StatefulWidget {
  final WorkOrder order;
  final Function(WorkOrder) onOrderUpdated;

  const OrderDetailScreen({
    super.key,
    required this.order,
    required this.onOrderUpdated,
  });

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final _observationController = TextEditingController();
  late WorkOrder _updatedOrder;

  @override
  void initState() {
    super.initState();
    _updatedOrder = widget.order;
    _observationController.text = widget.order.observation ?? '';
  }

  void _changeStatus(String newStatus) {
    setState(() {
      _updatedOrder = WorkOrder(
        orderNumber: _updatedOrder.orderNumber,
        client: _updatedOrder.client,
        phone: _updatedOrder.phone,
        address: _updatedOrder.address,
        reference: _updatedOrder.reference,
        workType: _updatedOrder.workType,
        scheduledDate: _updatedOrder.scheduledDate,
        timeSlot: _updatedOrder.timeSlot,
        status: newStatus,
        observation: _updatedOrder.observation,
        photoPath: _updatedOrder.photoPath,
      );
    });
    widget.onOrderUpdated(_updatedOrder);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Estado cambiado a $newStatus')),
    );
  }

  void _saveObservation() {
    setState(() {
      _updatedOrder = WorkOrder(
        orderNumber: _updatedOrder.orderNumber,
        client: _updatedOrder.client,
        phone: _updatedOrder.phone,
        address: _updatedOrder.address,
        reference: _updatedOrder.reference,
        workType: _updatedOrder.workType,
        scheduledDate: _updatedOrder.scheduledDate,
        timeSlot: _updatedOrder.timeSlot,
        status: _updatedOrder.status,
        observation: _observationController.text,
        photoPath: _updatedOrder.photoPath,
      );
    });
    widget.onOrderUpdated(_updatedOrder);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Observación guardada')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.order.orderNumber)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DetailItem(label: 'Cliente', value: widget.order.client),
            _DetailItem(label: 'Teléfono', value: widget.order.phone),
            _DetailItem(label: 'Dirección', value: widget.order.address),
            _DetailItem(label: 'Referencia', value: widget.order.reference),
            _DetailItem(label: 'Tipo de trabajo', value: widget.order.workType),
            _DetailItem(label: 'Fecha programada', value: widget.order.scheduledDate),
            _DetailItem(label: 'Franja horaria', value: widget.order.timeSlot),
            _DetailItem(label: 'Estado actual', value: widget.order.status),
            const SizedBox(height: 24),
            const Text('Cambiar estado:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => _changeStatus('Pendiente'),
                  child: const Text('Pendiente'),
                ),
                ElevatedButton(
                  onPressed: () => _changeStatus('En camino'),
                  child: const Text('En camino'),
                ),
                ElevatedButton(
                  onPressed: () => _changeStatus('En sitio'),
                  child: const Text('En sitio'),
                ),
                ElevatedButton(
                  onPressed: () => _changeStatus('Finalizada'),
                  child: const Text('Finalizada'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _observationController,
              decoration: const InputDecoration(
                labelText: 'Observación técnica',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveObservation,
              child: const Text('Guardar observación'),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Función de adjuntar foto simulada')),
                );
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Adjuntar foto'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _DetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
