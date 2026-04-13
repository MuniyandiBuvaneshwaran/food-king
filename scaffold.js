const fs = require('fs');
const path = require('path');

const adminScreens = [
  'Login', 'Dashboard', 'OnlineOrders', 'OnlineOrderDetail', 'POSOrders', 'POSOrderDetail',
  'TableOrders', 'TableOrderDetail', 'POSTerminal', 'KitchenDisplaySystem', 'OrderStatusScreen',
  'Items', 'ItemForm', 'ItemCategories', 'CategoryForm', 'Addons', 'AddonForm',
  'Branches', 'BranchForm', 'DiningTables', 'DiningTableForm', 'KioskMachines', 'KioskMachineForm',
  'Customers', 'CustomerDetail', 'DeliveryBoys', 'DeliveryBoyForm', 'Administrators', 'AdministratorForm',
  'Employees', 'EmployeeForm', 'Coupons', 'CouponForm', 'Offers', 'OfferForm', 'PaymentGateways',
  'SmsGateways', 'PushNotifications', 'Sliders', 'Pages', 'Subscribers', 'Messages',
  'TimeSlots', 'Currencies', 'Languages', 'RolesPermissions', 'SalesReport', 'ItemsReport', 
  'CreditBalanceReport', 'Settings'
];

const customerWebScreens = [
  'Home', 'Menu', 'ItemDetail', 'Cart', 'Checkout', 'OrderTracking', 'OrderHistory',
  'Profile', 'Addresses', 'Auth', 'StaticPage', 'Notifications'
];

const customerAppScreens = [
  'Splash', 'Onboarding', 'Auth', 'Home', 'Menu', 'ItemDetail', 'Cart', 'Checkout',
  'OrderTracking', 'OrderHistory', 'Profile', 'Addresses', 'Notifications', 'Chat', 'Wallet'
];

const deliveryAppScreens = [
  'Login', 'Home', 'OrderDetail', 'MapNavigation', 'DeliveryConfirmation', 'OrderHistory', 'Profile'
];

function createVueComponent(name, dir) {
  const content = `<template>
  <div class="p-6">
    <h1 class="text-2xl font-bold mb-4">${name}</h1>
    <div class="bg-card text-card-foreground shadow-sm rounded-lg border p-6">
      <p class="text-muted-foreground">This is the ${name} screen. Replace with actual implementation.</p>
    </div>
  </div>
</template>

<script setup>
// Component logic goes here
</script>
`;
  const filePath = path.join(dir, `${name}.vue`);
  if (!fs.existsSync(filePath)) {
    fs.writeFileSync(filePath, content);
    console.log(`Created: ${filePath}`);
  }
}

function createFlutterScreen(name, dir) {
  const className = name.replace(/[^a-zA-Z0-9]/g, '');
  const content = `import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ${className}Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${name}')),
      body: Center(
        child: Text('This is the ${name} screen. Replace with actual implementation.'),
      ),
    );
  }
}
`;
  const snakeName = name.replace(/([a-z])([A-Z])/g, '$1_$2').toLowerCase();
  const filePath = path.join(dir, `${snakeName}_screen.dart`);
  if (!fs.existsSync(filePath)) {
    fs.writeFileSync(filePath, content);
    console.log(`Created: ${filePath}`);
  }
}

// 1. Admin Dashboard
const adminDir = path.join(__dirname, 'apps', 'admin', 'src', 'pages', 'Generated');
if (!fs.existsSync(adminDir)) fs.mkdirSync(adminDir, { recursive: true });
adminScreens.forEach(screen => createVueComponent(screen, adminDir));

// 2. Customer Web
const webDir = path.join(__dirname, 'apps', 'customer-web', 'src', 'pages', 'Generated');
if (!fs.existsSync(webDir)) fs.mkdirSync(webDir, { recursive: true });
customerWebScreens.forEach(screen => createVueComponent(screen, webDir));

// 3. Customer App
const customerAppDir = path.join(__dirname, 'apps', 'customer-app', 'lib', 'screens');
if (!fs.existsSync(customerAppDir)) fs.mkdirSync(customerAppDir, { recursive: true });
customerAppScreens.forEach(screen => createFlutterScreen(screen, customerAppDir));

// 4. Delivery App
const deliveryAppDir = path.join(__dirname, 'apps', 'delivery-app', 'lib', 'screens');
if (!fs.existsSync(deliveryAppDir)) fs.mkdirSync(deliveryAppDir, { recursive: true });
deliveryAppScreens.forEach(screen => createFlutterScreen(screen, deliveryAppDir));

console.log('Scaffolding complete!');
