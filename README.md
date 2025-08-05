# Email Service API Documentation

This repository contains the documentation website for the Email Service API project.

## 🌐 Live Documentation

Visit the live documentation at: [https://niazbinsiraj.github.io/email-service/](https://niazbinsiraj.github.io/email-service/)

## 📋 What's New

### Latest Updates

- ✨ **Custom Sender Configuration**: Added support for custom `from` email address and `name` parameters
- 📧 **Flexible Sender Options**: Configure sender details per email for branded communications
- 🎨 **Enhanced UI**: Added dedicated section showcasing custom sender functionality with examples
- 📚 **Updated API Reference**: Complete documentation for all new parameters and validation rules

### New Features Documented

1. **Optional `from` Parameter**:
   - Allows custom sender email address
   - Validates email format
   - Falls back to configured Gmail address if not provided

2. **Optional `name` Parameter**:
   - Allows custom sender display name
   - 1-100 character validation
   - Defaults to "Email Service" if not provided

3. **Sender Configuration Examples**:
   - Default behavior (uses Gmail settings)
   - Custom name only
   - Custom from address only
   - Full custom configuration (both from and name)

## 🛠 Technical Details

### Website Structure

- `index.html` - Main documentation page
- `styles.css` - Styling and responsive design
- `script.js` - Interactive functionality
- `manifest.json` - PWA configuration
- `sitemap.xml` - SEO sitemap
- `robots.txt` - Search engine instructions

### Key Sections Updated

1. **Features Section**: Added "Custom Sender Details" feature card
2. **API Reference**: Updated request/response examples with new parameters
3. **Validation Rules**: Added documentation for `from` and `name` parameters
4. **Custom Sender Configuration**: New dedicated section with practical examples

## 🚀 Deployment

This documentation is automatically deployed to GitHub Pages from the `docs` branch.

### Local Development

To run the documentation locally:

1. Clone the repository
2. Switch to the `docs` branch
3. Open `index.html` in a web browser
4. Or serve using a local HTTP server:
   ```bash
   # Using Python
   python -m http.server 8000
   
   # Using Node.js
   npx serve .
   ```

## 📱 Features

- **Responsive Design**: Works on desktop, tablet, and mobile devices
- **Modern UI**: Clean, professional design with smooth animations
- **Interactive Examples**: Copy-able code examples and API responses
- **SEO Optimized**: Proper meta tags, structured data, and sitemap
- **Fast Loading**: Optimized assets and minimal dependencies

## 🔗 Related Links

- [Main Repository](https://github.com/NiazBinSiraj/email-service)
- [API Documentation](https://niazbinsiraj.github.io/email-service/#api-reference)
- [Getting Started Guide](https://niazbinsiraj.github.io/email-service/#getting-started)

---

Built with ❤️ for developers who need a reliable email API solution.
