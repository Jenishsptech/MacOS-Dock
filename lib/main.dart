import 'package:flutter/material.dart';
import 'package:untitled/docker.dart';

void main() => runApp(DockerApp());



class DockerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DockerAnimation(),
    );
  }
}
