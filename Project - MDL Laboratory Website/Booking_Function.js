// Create_Calendar_Event
 
function Create_Calendar_Event() 
{
  //Set data from Spread Sheet
  var spreadSheetID = "Your SpreadsheetsID";
  var ss = SpreadsheetApp.openById(spreadSheetID);
  var sheet = ss.getActiveSheet();
  var lastRow = sheet.getLastRow();
  var lastColumn = sheet.getLastColumn();
   
  //Logger.log(lastRow);
  //Logger.log(lastColumn);
 
  //Set data for Google Calendar
  var ชื่อนามสกุลผู้จอง = sheet.getRange(lastRow, 4).getValue();
  var เบอร์โทรศัพท์หรือเบอร์ติดต่อภายใน = sheet.getRange(lastRow, 5).getValue();
  var ห้องปฏิบัติการที่ต้องการจอง = sheet.getRange(lastRow, 6).getValue();
  var วันที่และเวลาที่ต้องการใช้ห้อง  = new Date(sheet.getRange(lastRow, 8).getValue());
  var วันที่และเวลาที่สิ้นสุดการใช้ห้อง = new Date(sheet.getRange(lastRow, 9).getValue());
  var หัวข้อปฏิบัติการ = sheet.getRange(lastRow, 11).getValue()
 
  /*
  Logger.log("ชื่อ นามสกุลผู้จอง:" + ชื่อนามสกุลผู้จอง);
  Logger.log("เบอร์โทรศัพท์หรือเบอร์ติดต่อภายใน:" + เบอร์โทรศัพท์หรือเบอร์ติดต่อภายใน);
  Logger.log("ห้องปฏิบัติการที่ต้องการจอง:" + ห้องปฏิบัติการที่ต้องการจอง);
  Logger.log("วันที่ และเวลาที่ต้องการใช้ห้อง:" + วันที่และเวลาที่ต้องการใช้ห้อง);
  Logger.log("วันที่ และเวลาที่สิ้นสุดการใช้ห้อง:" + วันที่และเวลาที่สิ้นสุดการใช้ห้อง);
  Logger.log("หัวข้อปฏิบัติการ:" + หัวข้อปฏิบัติการ);
  */
 
  //Creates a calendar event using the submitted data
 
  var calendar = CalendarApp.getCalendarById("Your CalendarID");
 
  var titles = ('คุณ ' + ชื่อนามสกุลผู้จอง + ' ' + 'Tel: ' + เบอร์โทรศัพท์หรือเบอร์ติดต่อภายใน + ' ' + 'ห้อง: ' + ห้องปฏิบัติการที่ต้องการจอง);
 
  var descriptions = 'หัวข้อปฏิบัติการ : '+'"'+ หัวข้อปฏิบัติการ+'"';
 
  calendar.createEvent(titles, วันที่และเวลาที่ต้องการใช้ห้อง, วันที่และเวลาที่สิ้นสุดการใช้ห้อง, {description: descriptions});
}
 
 
// Send Notify to Line by Line Notify
 
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
      var ผู้จอง                = sheet.getRange(lastRow, 4).getValue();
      var ภาควิชาหน่วยงาน       = sheet.getRange(lastRow, 3).getValue();
      var เบอร์โทรติดต่อภายใน    = sheet.getRange(lastRow, 5).getValue();
      var หัวข้อ                = sheet.getRange(lastRow, 11).getValue();
      var ใช้งานห้อง            = sheet.getRange(lastRow, 6).getValue();
      var เริ่มใช้งาน             = sheet.getRange(lastRow, 8).getDisplayValues();
      var เลิกใช้งาน             = sheet.getRange(lastRow, 9).getDisplayValues();
      var จำนวนผู้ใช้งาน          = sheet.getRange(lastRow, 10).getValue();
      var กรอกข้อมูล            = sheet.getRange(lastRow, 1).getDisplayValues();
       
   /*
  Logger.log("กรอกข้อมูล:" + กรอกข้อมูล);
  Logger.log("ผู้จอง:" + ผู้จอง);
  Logger.log("ภาควิชา/หน่วยงาน:" + ภาควิชา/หน่วยงาน);
  Logger.log("เบอร์โทรติดต่อ/ภายใน:" + เบอร์โทรติดต่อ/ภายใน);
  Logger.log("หัวข้อ:" + หัวข้อ);
  Logger.log("ใช้งานห้อง:" + ใช้งานห้อง);
  Logger.log("เริ่มใช้งาน:" + เริ่มใช้งาน);
  Logger.log("เลิกใช้งาน:" + เลิกใช้งาน);
  Logger.log("จำนวนผู้ใช้งาน:" + จำนวนผู้ใช้งาน);
  Logger.log(“กรอกข้อมูล:” + กรอกข้อมูล);
  */
   
  // Create Massage
  var message = "";
     message = '\n' + 'จองห้องปฏิบัติการรวม(MDL)'+'\n' + '\n' +'ผู้จอง : '+ ผู้จอง + '\n' +
                      'ภาควิชา/หน่วยงาน : ' + ภาควิชาหน่วยงาน + '\n' +
                      'เบอร์โทรติดต่อ/ภายใน : ' + เบอร์โทรติดต่อภายใน + '\n' +
                      'หัวข้อ : ' + หัวข้อ + '\n' +
                      'ใช้งานห้อง : ' + ใช้งานห้อง + '\n' +
                      'เริ่มใช้งาน : ' + เริ่มใช้งาน + '\n' +
                      'เลิกใช้งาน : ' + เลิกใช้งาน + '\n' +
                      'จำนวนผู้ใช้งาน : ' + จำนวนผู้ใช้งาน + '\n'+ '\n' +
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
