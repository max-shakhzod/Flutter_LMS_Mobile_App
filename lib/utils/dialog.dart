import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:nb_utils/nb_utils.dart';

// import 'color.dart';

showLoading(BuildContext context){

  var width = MediaQuery.of(context).size.width/7*2;
  var dialog = SimpleDialog(
    insetPadding: EdgeInsets.symmetric(horizontal: width),
    children: [
      Center(
        child: Column(children: const [
          SizedBox(height: 30),
          CircularProgressIndicator(),
          SizedBox(height: 30),
        ]),
      )
    ],
    elevation: 24,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
  );

  showDialog(
    context: context,
    builder: (_) => dialog,
    barrierDismissible: false,
  );
}

showActionDialog(BuildContext context, String? title, String content, VoidCallback callback, {String positiveLabel = 'YES', String negativeLabel = 'CANCEL', Color positiveColor = Colors.green, callback2}){
  var dialog = AlertDialog(
    title: title == null ? null : Text(title, style: GoogleFonts.poppins().copyWith(fontSize: 17, fontWeight: FontWeight.w600)),
    content: Text(content,style: GoogleFonts.poppins().copyWith(fontSize: 15)),
    elevation: 24,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
    actions: [
      TextButton(onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        if(callback2 != null){
          callback2();
        }
      }, child: Text(negativeLabel,style: GoogleFonts.poppins().copyWith(fontWeight: FontWeight.w600, color: Colors.grey))),
      TextButton(onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        callback();
      }, child: Text(positiveLabel,style: GoogleFonts.poppins().copyWith(fontWeight: FontWeight.w600, color: positiveColor)))
    ],
  );

  showDialog(
    context: context,
    builder: (_) => dialog,
    barrierDismissible: true,
  );
}

showInfoDialog(BuildContext context, String? title, String content, {String positiveLabel = 'CLOSE', callback}){
  var dialog = AlertDialog(
    title: title == null ? null : Text(title, style: GoogleFonts.poppins().copyWith(fontSize: 17, fontWeight: FontWeight.w600)),
    content: Text(content,style: GoogleFonts.poppins().copyWith(fontSize: 15)),
    elevation: 24,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
    actions: [
      TextButton(onPressed: () {
        if(positiveLabel.toLowerCase().contains('copy')) {
          Clipboard.setData(ClipboardData(text: content));
        }

        Navigator.of(context, rootNavigator: true).pop();

        if(callback != null){
          callback();
        }

      }, child: Text(positiveLabel,style: GoogleFonts.poppins().copyWith(fontWeight: FontWeight.w600)))
    ],
  );

  showDialog(
    context: context,
    builder: (_) => dialog,
    barrierDismissible: true,
  );
}

showInfoDialogCallback(BuildContext context, String? title, String content, {String positiveLabel = 'CLOSE', callback}){
  var dialog = AlertDialog(
    title: title == null ? null : Text(title, style: GoogleFonts.poppins().copyWith(fontSize: 17, fontWeight: FontWeight.w600)),
    content: Text(content,style: GoogleFonts.poppins().copyWith(fontSize: 15)),
    elevation: 24,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
    actions: [
      TextButton(onPressed: () {
        if(positiveLabel.toLowerCase().contains('copy')) {
          Clipboard.setData(ClipboardData(text: content));
        }

        Navigator.of(context, rootNavigator: true).pop();
      }, child: Text(positiveLabel,style: GoogleFonts.poppins().copyWith(fontWeight: FontWeight.w600)))
    ],
  );

  showDialog(
    context: context,
    builder: (_) => dialog,
    barrierDismissible: true,
  ).then((value){
    if(callback != null){
      callback();
    }
  });
}

showRichInfoDialog(BuildContext context, String? title, String contentNormal, String contentBold, {String positiveLabel = 'CLOSE'}){
  var dialog = AlertDialog(
    title: title == null ? null : Text(title, style: GoogleFonts.poppins().copyWith(fontSize: 17, fontWeight: FontWeight.w600)),
    content: RichText(
        text: TextSpan(
            text: contentNormal,
            style: GoogleFonts.poppins(
              textStyle: GoogleFonts.poppins().copyWith(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  color: Colors.black),
            ),
            children: [
              TextSpan(
                  text: contentBold,
                  style: GoogleFonts.poppins(
                    textStyle: GoogleFonts.poppins().copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.red),
                  )),
            ])),
    elevation: 24,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
    actions: [
      TextButton(onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      }, child: Text(positiveLabel,style: GoogleFonts.poppins().copyWith(fontWeight: FontWeight.w600)))
    ],
  );

  showDialog(
    context: context,
    builder: (_) => dialog,
    barrierDismissible: true,
  );
}

showSuccessDialog(BuildContext context, String? title, String content, VoidCallback callback, {String positiveLabel = 'CLOSE'}){
  var dialog = AlertDialog(
    title: title == null ? null : Row(
      children: [
        const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 30,
        ),
        const SizedBox(width: 10),
        Text(title, style: GoogleFonts.poppins().copyWith(fontSize: 17, fontWeight: FontWeight.w600))
      ],
    ),
    content: Text(content,style: GoogleFonts.poppins().copyWith(fontSize: 15)),
    elevation: 24,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
    actions: [
      TextButton(onPressed: () {
        if(positiveLabel.toLowerCase().contains('copy')) {
          Clipboard.setData(ClipboardData(text: content));
        }

        Navigator.of(context, rootNavigator: true).pop();
      }, child: Text(positiveLabel,style: GoogleFonts.poppins().copyWith(fontWeight: FontWeight.w600)))
    ],
  );

  showDialog(
    context: context,
    builder: (_) => dialog,
    barrierDismissible: false,
  ).then((value){
    callback();
  });
}

showInfoDialogTest(BuildContext context, String? title, String content, {String positiveLabel = 'CLOSE'}){
  var dialog = Dialog(
      elevation: 24,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 56,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.green[300]!,
                      Colors.green[400]!,
                      Colors.green[500]!,
                    ]),
                borderRadius: BorderRadius.circular(9.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white, size: 40),
                    const SizedBox(width: 24),
                    Text('Success', style: GoogleFonts.poppins().copyWith(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600
                    ))
                  ],
                )

              ],
            ),

          )
        ],
      )

  );
  showDialog(
    context: context,
    builder: (_) => dialog,
    barrierDismissible: true,
  );
}

showCommentOption(BuildContext context, bool showDelete, Function (String) callback){
  var dialog = AlertDialog(
    title: Text('Action', style: GoogleFonts.poppins().copyWith(fontSize: 17, fontWeight: FontWeight.w600)),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 11, bottom: 11),
          child: Text('Reply', style: GoogleFonts.poppins().copyWith(
              fontSize: 14.5,
              fontWeight: FontWeight.w400
          )),
        ).onTap((){
          callback('reply');
        }),
        Container(
          padding: const EdgeInsets.only(top: 11, bottom: 11),
          child: Text('Forward', style: GoogleFonts.poppins().copyWith(
              fontSize: 14.5,
              fontWeight: FontWeight.w400
          )),
        ).onTap((){
          callback('forward');
        }),
        showDelete ? Container(
          padding: const EdgeInsets.only(top: 11, bottom: 11),
          child: Text('Delete', style: GoogleFonts.poppins().copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 14.5,
              color: Colors.red
          )),
        ).onTap((){
          callback('delete');
        }) : const SizedBox(),
      ],
    ),

    elevation: 24,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
  );

  showDialog(
    context: context,
    builder: (_) => dialog,
    barrierDismissible: true,
  );
}


/*  getError  */
//TODO: coop with firebase error
// dynamic getError(dynamic e){
//     DioError error = e;
//     if (error.type == DioErrorType.response) {
//
//       /*  Clear user data if error 401  */
//       if(error.response?.statusCode == 401) {
//         return ErrorType.sessionExpired;
//       }
//     }
//   }
//
//   return getErrorAPI(e);
// }
//
// dynamic getErrorAPI(dynamic e){
//
//   if(e is DioError) {
//     DioError error = e;
//
//     if (error.type == DioErrorType.response) {
//       Map loginResp = error.response!.data;
//       var response = GeneralResponse.fromMap(loginResp);
//       if (response != null && response.message != null) {
//         if(error.response?.statusCode == 500 && response.message != null && response.message!.contains("Connection timed out")){
//           return ErrorType.serverMaintenance;
//         }else {
//           if(response.message != null){
//             if(response.message!.contains("SQLSTATE")){
//               return ErrorType.responseError;
//             }else {
//               return response.message;
//             }
//           }else{
//             return ErrorType.responseError;
//           }
//         }
//       } else {
//         return ErrorType.connectionError;
//       }
//     } else if (error.type == DioErrorType.connectTimeout ||
//         error.type == DioErrorType.receiveTimeout ||
//         error.type == DioErrorType.sendTimeout) {
//
//       return ErrorType.timeoutError;
//     } else {
//       if (error.message.toLowerCase().contains('socket') ||
//           error.message.toLowerCase().contains('network') ||
//           error.message.toLowerCase().contains('server')) {
//
//         return ErrorType.connectionError;
//       } else {
//         return ErrorType.connectionError;
//       }
//     }
//   }else{
//     return ErrorType.responseError;
//   }
//
// }
//
// enum ErrorType {
//   sessionExpired,
//   serverMaintenance,
//   responseError,
//   connectionError,
//   timeoutError
// }
