// Sent Massage to Line Notify
 
function Notify() 
{
  //Set data from Spread Sheet
  var spreadSheetID = "Your SpreadsheetID";
  var ss = SpreadsheetApp.openById(spreadSheetID);
  var sheet = ss.getActiveSheet();
  var lastRow = sheet.getLastRow();
  var lastColumn = sheet.getLastColumn();
   
  //Logger.log(lastRow);
  //Logger.log(lastColumn);
   
  //Set data for message
      var ผู้จอง                = sheet.getRange(lastRow, 3).getValue();
      var ภาควิชาหน่วยงาน       = sheet.getRange(lastRow, 6).getValue();
      var เบอร์โทรติดต่อภายใน    = sheet.getRange(lastRow, 4).getValue();
      var วัตถุประสงค์           = sheet.getRange(lastRow, 7).getValue();
      var วันที่ยืม             = sheet.getRange(lastRow, 8).getDisplayValues();
      var กำหนดส่งคืน            = sheet.getRange(lastRow, 9).getDisplayValues();
      var กรอกข้อมูล            = sheet.getRange(lastRow, 1).getDisplayValues();
       
   /*
  Logger.log("ผู้จอง:" + ผู้จอง);
  Logger.log("ภาควิชา/หน่วยงาน:" + ภาควิชา/หน่วยงาน);
  Logger.log("เบอร์โทรติดต่อ/ภายใน:" + เบอร์โทรติดต่อ/ภายใน);
  Logger.log("วัตถุประสงค์:" + วัตถุประสงค์);
  Logger.log("วันที่ยืม:" + วันที่ยืม);
  Logger.log("เริ่มใช้งาน:" + เริ่มใช้งาน);
  Logger.log("กำหนดส่งคืน:" + กำหนดส่งคืน);
  Logger.log(“กรอกข้อมูล:” + กรอกข้อมูล);
  */
   
  // Create Massage
  var message = "";
     message = '\n' + 'ยืม-คืนครุภัณฑ์และวัสดุ(MDL)'+'\n' + '\n' +'ผู้จอง : '+ ผู้จอง + '\n' +
                      'ภาควิชา/หน่วยงาน : ' + ภาควิชาหน่วยงาน + '\n' +
                      'เบอร์โทรติดต่อ/ภายใน : ' + เบอร์โทรติดต่อภายใน + '\n' +
                      'วัตถุประสงค : ' + วัตถุประสงค์ + '\n' +
                      'วันที่ยืม : ' + วันที่ยืม + '\n' +
                      'กำหนดส่งคืน : ' + กำหนดส่งคืน + '\n' + '\n' +
                      'กรอกฟอร์ม : ' + กรอกข้อมูล ;                
                      
   Logger.log("message :" + message);
    
   sendMessage(message);
} 
    
   //Sent Massage to Line Notify
    
function sendMessage(message) 
{
  var lineNotifyEndPoint = "https://notify-api.line.me/api/notify";
  var accessToken = "Your Line Notify Token";
 
  var formData = {
    "message": message
  };
   
  var options = {
    "headers" : {"Authorization" : "Bearer " + accessToken},
    "method" : 'post',
    "payload" : formData
  };
 
  try {
    var response = UrlFetchApp.fetch(lineNotifyEndPoint, options);
  }
   
  catch (error) {
    Logger.log(error.name + "：" + error.message);
    return;
  }
     
  if (response.getResponseCode() === 200) {
    Logger.log("Sending message completed.");
  } 
}
