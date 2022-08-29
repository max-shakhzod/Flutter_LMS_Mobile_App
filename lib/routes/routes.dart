import 'package:flutter/material.dart';
import 'package:fyp_lms/ui/auth_screen/create_account_screen.dart';
import 'package:fyp_lms/ui/course/add_course_screen.dart';
import 'package:fyp_lms/ui/course/course_material_screen.dart';
import 'package:fyp_lms/ui/image/image_preview_screen.dart';
import 'package:fyp_lms/ui/post/add_post_screen.dart';
import 'package:fyp_lms/ui/course/course_detail_screen.dart';
import 'package:fyp_lms/ui/home/course_listing_screen.dart';
import 'package:fyp_lms/ui/home/dashboard_screen.dart';

import 'package:fyp_lms/ui/home/home_screen.dart';
import 'package:fyp_lms/ui/auth_screen/intro_screen.dart';
import 'package:fyp_lms/ui/home/profile_screen.dart';
import 'package:fyp_lms/ui/home/uploaded_file_screen.dart';
import 'package:fyp_lms/ui/splash_screen.dart';
import 'package:fyp_lms/ui/auth_screen/verification_screen.dart';

import '../ui/post/post_detail_screen.dart';


Map<String, Widget Function(BuildContext)> routesName = {
  '/SplashScreen': (context) => const SplashScreen(),

  '/': (context) => const HomeScreen(),
  '/Login': (context) => const IntroScreen(),
  '/VerificationScreen': (context) => const VerificationScreen(),
  '/CreateAccountScreen': (context) => const CreateAccountScreen(),

  '/DashboardScreen': (context) => const DashboardScreen(),
  '/CourseListingScreen': (context) => const CourseListingScreen(),
  '/UploadedFileScreen': (context) => const UploadedFileScreen(),
  '/ProfileScreen': (context) => const ProfileScreen(),

  '/AddCourseScreen': (context) => const AddCourseScreen(),
  '/CourseDetailScreen': (context) => const CourseDetailScreen(),
  '/CourseMaterialScreen': (context) => const CourseMaterialScreen(),

  '/AddPostScreen': (context) => const AddPostScreen(),
  '/PostDetailScreen': (context) => const PostDetailScreen(),

  '/ImagePreviewScreen': (context) => const ImagePreviewScreen(),
};