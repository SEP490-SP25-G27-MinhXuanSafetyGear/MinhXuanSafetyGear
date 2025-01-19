﻿using BusinessLogicLayer.Models;
using MimeKit;
using MailKit.Net.Smtp;
using BusinessLogicLayer.Services.Interface;
using Microsoft.Extensions.Options;

namespace BusinessLogicLayer.Services
{
    public class MailService : IMailService
    {
        private readonly EmailSettings _emailSettings;

        public MailService(IOptions<EmailSettings> emailSettings)
        {
            _emailSettings = emailSettings.Value;
        }

        public async Task<bool> SendEmailAsync(string toEmail, string subject, string username)
        {
            try
            {
                var message = new MimeMessage();
                message.From.Add(new MailboxAddress("No Reply", _emailSettings.SmtpUser));
                message.To.Add(new MailboxAddress("", toEmail));
                message.Subject = subject;

                // HTML content with account registration details
                string htmlBody = $@"
                    <html>
                        <body>
                            <h2>Chào mừng bạn đến với hệ thống của chúng tôi!</h2>
                            <p>Xin chúc mừng, {username}! Bạn đã đăng ký tài khoản thành công.</p>
                            <p>Thông tin tài khoản của bạn:</p>
                            <table border='1' cellpadding='10'>
                                <tr>
                                    <td><strong>Tên tài khoản</strong></td>
                                    <td>{username}</td>
                                </tr>
                                <tr>
                                    <td><strong>Email</strong></td>
                                    <td>{toEmail}</td>
                                </tr>
                            </table>
                            <p>Vui lòng lưu thông tin này để đăng nhập và sử dụng các dịch vụ của chúng tôi.</p>
                            <p>Nếu bạn có bất kỳ câu hỏi nào, đừng ngần ngại liên hệ với chúng tôi.</p>
                            <p>Chúc bạn có một trải nghiệm tuyệt vời!</p>
                            <p>Trân trọng,<br />Đội ngũ hỗ trợ</p>
                        </body>
                    </html>";

                var bodyBuilder = new BodyBuilder
                {
                    HtmlBody = htmlBody
                };
                message.Body = bodyBuilder.ToMessageBody();

                using (var client = new SmtpClient())
                {
                    await client.ConnectAsync(_emailSettings.SmtpHost, _emailSettings.SmtpPort, true);
                    await client.AuthenticateAsync(_emailSettings.SmtpUser, _emailSettings.SmtpPassword);
                    await client.SendAsync(message);
                    await client.DisconnectAsync(true);
                }

                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error sending email: {ex.Message}");
                return false;
            }
        }
        public async Task<bool> SendVerificationEmailAsync(string toEmail, string verificationCode)
{
    try
    {
        var message = new MimeMessage();
        message.From.Add(new MailboxAddress("Bảo Hộ Lao Động Minh Xuân", _emailSettings.SmtpUser));
        message.To.Add(new MailboxAddress("", toEmail));
        message.Subject = "Mã xác thực tài khoản của bạn";

        // Tạo đường dẫn xác thực
        string verificationLink = $"https://yourwebsite.com/verify?code={verificationCode}";

        // Nội dung email với mã xác thực và nút xác thực
        string htmlBody = $@"
        <html>
            <body>
                <h2>Chào bạn!</h2>
                <p>Để hoàn tất quá trình đăng ký tài khoản, vui lòng nhập mã xác thực dưới đây hoặc nhấn vào nút để xác thực tài khoản của bạn:</p>
                
                <p><strong>Mã xác thực:</strong> {verificationCode}</p>
                
                <p>Hoặc bạn có thể nhấn vào nút dưới đây để xác thực tài khoản:</p>
                <a href='{verificationLink}' style='padding: 10px 20px; background-color: #4CAF50; color: white; text-decoration: none; border-radius: 5px;'>Xác thực tài khoản</a>

                <p>Vui lòng không chia sẻ mã xác thực này với bất kỳ ai để bảo mật tài khoản của bạn.</p>
                <p>Trân trọng,<br />Đội ngũ hỗ trợ</p>
            </body>
        </html>";

        var bodyBuilder = new BodyBuilder
        {
            HtmlBody = htmlBody
        };
        message.Body = bodyBuilder.ToMessageBody();

        using (var client = new SmtpClient())
        {
            await client.ConnectAsync(_emailSettings.SmtpHost, _emailSettings.SmtpPort, true);
            await client.AuthenticateAsync(_emailSettings.SmtpUser, _emailSettings.SmtpPassword);
            await client.SendAsync(message);
            await client.DisconnectAsync(true);
        }

        return true;
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Error sending verification email: {ex.Message}");
        return false;
    }
}

        public async Task<bool> SendOrderConfirmationEmailAsync(string toEmail, string orderNumber, string orderDetails)
        {
            try
            {
                var message = new MimeMessage();
                message.From.Add(new MailboxAddress("No Reply", _emailSettings.SmtpUser));
                message.To.Add(new MailboxAddress("", toEmail));
                message.Subject = "Xác nhận đơn hàng của bạn";

                string htmlBody = $@"
            <html>
                <body>
                    <h2>Chào bạn!</h2>
                    <p>Chúng tôi đã nhận được đơn hàng của bạn với mã đơn hàng: <strong>{orderNumber}</strong>.</p>
                    <p>Thông tin đơn hàng:</p>
                    <pre>{orderDetails}</pre>
                    <p>Chúng tôi sẽ xử lý đơn hàng của bạn và thông báo khi đơn hàng được giao.</p>
                    <p>Trân trọng,<br />Đội ngũ hỗ trợ</p>
                </body>
            </html>";

                var bodyBuilder = new BodyBuilder
                {
                    HtmlBody = htmlBody
                };
                message.Body = bodyBuilder.ToMessageBody();

                using (var client = new SmtpClient())
                {
                    await client.ConnectAsync(_emailSettings.SmtpHost, _emailSettings.SmtpPort, true);
                    await client.AuthenticateAsync(_emailSettings.SmtpUser, _emailSettings.SmtpPassword);
                    await client.SendAsync(message);
                    await client.DisconnectAsync(true);
                }

                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error sending order confirmation email: {ex.Message}");
                return false;
            }
        }
        public async Task<bool> SendAccountCreatedEmailAsync(string toEmail, string username) 
        { 
            try 
            {
        var message = new MimeMessage();
        message.From.Add(new MailboxAddress("No Reply", _emailSettings.SmtpUser));
        message.To.Add(new MailboxAddress("", toEmail));
        message.Subject = "Tài khoản của bạn đã được tạo thành công";
        string htmlBody = $@"
            <html>
                <body>
                    <h2>Chào mừng bạn đến với hệ thống của chúng tôi!</h2>
                    <p>Xin chúc mừng, {username}! Bạn đã đăng ký tài khoản thành công.</p>
                    <p>Thông tin tài khoản của bạn:</p>
                    <table border='1' cellpadding='10'>
                        <tr>
                            <td><strong>Tên tài khoản</strong></td>
                            <td>{username}</td>
                        </tr>
                        <tr>
                            <td><strong>Email</strong></td>
                            <td>{toEmail}</td>
                        </tr>
                    </table>
                    <p>Vui lòng lưu thông tin này để đăng nhập và sử dụng các dịch vụ của chúng tôi.</p>
                    <p>Nếu bạn có bất kỳ câu hỏi nào, đừng ngần ngại liên hệ với chúng tôi.</p>
                    <p>Chúc bạn có một trải nghiệm tuyệt vời!</p>
                    <p>Trân trọng,<br />Đội ngũ hỗ trợ</p>
                </body>
            </html>";

        var bodyBuilder = new BodyBuilder
        {
            HtmlBody = htmlBody
        };
        message.Body = bodyBuilder.ToMessageBody();

        using (var client = new SmtpClient())
        {
            await client.ConnectAsync(_emailSettings.SmtpHost, _emailSettings.SmtpPort, true);
            await client.AuthenticateAsync(_emailSettings.SmtpUser, _emailSettings.SmtpPassword);
            await client.SendAsync(message);
            await client.DisconnectAsync(true);
        }

        return true;
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Error sending account creation email: {ex.Message}");
        return false;
    }
}

    }
}
