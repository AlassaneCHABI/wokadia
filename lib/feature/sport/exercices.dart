import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wokadia/feature/sport/felicitation_cardio.dart';
import 'package:wokadia/feature/utils/constant.dart';
import 'package:wokadia/feature/utils/db_manager.dart';
import 'package:wokadia/models/exercice.dart';
import 'package:wokadia/models/programme.dart';

class ExercisePlayerPage extends StatefulWidget {
  final Programme programme;

  const ExercisePlayerPage({super.key, required this.programme});

  @override
  State<ExercisePlayerPage> createState() => _ExercisePlayerPageState();
}

class _ExercisePlayerPageState extends State<ExercisePlayerPage> {
  final DbManager dbManager = DbManager();
  List<Exercice> exercises = [];
  int currentIndex = 0;
  bool loading = true;

  int? remainingTime;
  Timer? _timer;

  // ✅ Chronomètre global
  int elapsedSeconds = 0;
  Timer? _globalTimer;

  double get _progress => (currentIndex + 1) / exercises.length;

  @override
  void initState() {
    super.initState();
    loadExercises();
  }

  Future<void> loadExercises() async {
    final loadedExercises = await dbManager.getExercisesByProgramme(widget.programme.id!);
    setState(() {
      exercises = loadedExercises;
      loading = false;
    });
    startTimerIfNeeded();
    startGlobalTimer();
  }

  // ✅ Chrono global
  void startGlobalTimer() {
    _globalTimer?.cancel();
    _globalTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsedSeconds++;
      });
    });
  }

  void startTimerIfNeeded() {
    _timer?.cancel();
    final exercise = exercises[currentIndex];

    if (exercise.durationSeconds!=0) {
      remainingTime = exercise.durationSeconds;
      if (remainingTime! > 0) {
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (remainingTime! > 0) {
            setState(() => remainingTime = remainingTime! - 1);
          } else {
            _timer?.cancel();
          }
        });
      }
    } else {
      remainingTime = null; // répétitions → pas de timer
    }
  }

  Future<void> _nextExercise() async {
    _timer?.cancel();
    if (currentIndex < exercises.length - 1) {
      setState(() {
        currentIndex++;
      });
      startTimerIfNeeded();
    } else {
      _globalTimer?.cancel(); // Stop le chrono global
      await DbManager().updateProgrammeScore(widget.programme.onlineId!);
      await DbManager().updateSelectedProgramme(widget.programme.onlineId!,elapsedSeconds);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => FelicitationCardio(programme: widget.programme,totalTime: elapsedSeconds,)),
      );
    }
  }

  // ✅ Fonction format du temps global (mm:ss)
  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _globalTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final exercise = exercises[currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Top bar
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, size: 32, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  // const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 18, // 👈 hauteur personnalisée
                      child: LinearProgressIndicator(
                        value: _progress,
                        borderRadius: BorderRadius.circular(30),
                        backgroundColor: Vert.withOpacity(0.2),
                        color: Vert,
                      ),
                    ),
                  ),
                ],
              ),
              /*Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: _progress,
                      minHeight: 8,
                      backgroundColor: Colors.green.shade100,
                      color: Vert,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),*/

              // ✅ Affichage du chrono global
              Text(
                "⏱ Temps total : ${formatTime(elapsedSeconds)}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),

              // Exercise image
              exercise.exerciseIcon != ""
                  ? Image.file(
                File(exercise.exerciseIcon),
                fit: BoxFit.contain,
                height: 200,
              )
                  : const SizedBox(height: 200),

              const SizedBox(height: 20),

              // Title
              Text(
                exercise.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Timer or reps
              Text(
                remainingTime != null ? "$remainingTime sec" : exercise.instruction,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center
              ),

              const Spacer(),

              // Terminer button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextExercise,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Vert,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    currentIndex < exercises.length - 1 ? "Terminer" : "Finir",
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
