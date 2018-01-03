package org.mountsinai.mortalitytriggersystem

import org.clapper.util.mail.StringDataSource

import javax.activation.DataHandler
import javax.activation.DataSource
import javax.mail.*
import javax.mail.internet.InternetAddress
import javax.mail.internet.MimeBodyPart
import javax.mail.internet.MimeMessage
import javax.mail.internet.MimeMultipart

class EmailHandler implements Runnable {
    
    private EmailHandler() {}
    private String from, subject, emailMessage
    private String toEmailList_csv, ccEmailList_csv
    private boolean multipartFlag = false
    private  boolean highImportance =  false
    private Map multipartParams = null

    static boolean sendEmail(String from, String toEmailList_csv, String ccEmailList_csv, String subject, String message,highImportance) {
        boolean emailInitiated = false
        try {
            EmailHandler instance = new EmailHandler()
            instance.ccEmailList_csv = ccEmailList_csv
            instance.toEmailList_csv = toEmailList_csv
            instance.from = from
            instance.subject = subject
            instance.emailMessage = message
            instance.highImportance = highImportance

            new Thread(instance).start()
            emailInitiated = true
        } catch(Exception e) { e.printStackTrace() }
        return emailInitiated;
    }

    static boolean sendEmailWithCSVAttachment(def params) {
        boolean emailInitiated = false
        try {
            EmailHandler instance = new EmailHandler()
            instance.ccEmailList_csv = params.ccEmailList_csv
            instance.toEmailList_csv = params.toEmailList_csv
            instance.from = params.from
            instance.subject = params.subject
            instance.emailMessage = params.message
            instance.multipartFlag = true
            instance.multipartParams = params

            new Thread(instance).start()
            emailInitiated = true
        } catch(Exception e) { e.printStackTrace() }
        return emailInitiated;
    }

    def void run() {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", "smtp.msnyuhealth.org");
            props.put("mail.smtp.from", "do-not-reply@mountsinai.org");
            
            Session session = Session.getInstance(props, null);
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress( (from == null)? "do-not-reply@mountsinai.org" :from));
            message.setRecipients(Message.RecipientType.TO,    InternetAddress.parse(toEmailList_csv));
            if(ccEmailList_csv!=null) {
                message.setRecipients(Message.RecipientType.CC,    InternetAddress.parse(ccEmailList_csv));
            }

            if(multipartFlag == true) {
                BodyPart messageBodyPart = new MimeBodyPart();

                messageBodyPart.setText(multipartParams.message_text);
                Multipart multipart = new MimeMultipart();
                multipart.addBodyPart(messageBodyPart);
                messageBodyPart = new MimeBodyPart();
                DataSource source = new StringDataSource(multipartParams.csv_date_string,"application/vnd.ms-excel","report.csv")
                messageBodyPart.setDataHandler(new DataHandler(source));
                messageBodyPart.setFileName("report.csv");
                multipart.addBodyPart(messageBodyPart);
                message.setContent(multipart);
            } else {
                message.setContent(emailMessage, "text/html");
            }

            message.setHeader("Return-Path", "do-not-reply@mountsinai.org")
            message.setHeader("X-Mailer", "Mortality Review Trigger Tool")
            if (highImportance == true) {
                message.setHeader("X-Priority", "1");
            }
            message.setSubject(subject);

            Transport.send(message);
        } catch(Exception e) { e.printStackTrace() }
    }

}