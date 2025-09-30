package Util;

import java.io.UnsupportedEncodingException;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class EmailUtil {

    private static final String USERNAME = "gangape04@gmail.com";
    private static final String APP_PASSWORD = "labkknpwfyhbxvbx"; // app password Gmail

    public static void enviarCodigoVerificacion(String destino, String codigo) throws MessagingException, UnsupportedEncodingException {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(USERNAME, APP_PASSWORD);
            }
        });

        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(USERNAME, "NOVA'S TRAVELS"));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destino));
        msg.setSubject("Código de verificación - NOVA'S TRAVELS");
        String cuerpo = "<p>Tu código de verificación es: <b>" + codigo + "</b></p>"
                      + "<p>Válido por 5 minutos.</p>";
        msg.setContent(cuerpo, "text/html; charset=utf-8");

        Transport.send(msg);
    }
}
