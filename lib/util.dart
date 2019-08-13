import 'dart:convert';
import 'package:crypto/crypto.dart';

String generateMd5(String input) => md5.convert(utf8.encode(input)).toString();

