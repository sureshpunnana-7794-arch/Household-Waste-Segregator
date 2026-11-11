const fs = require('fs');
const pdfPath = 'C:/Users/Suresh/.gemini/antigravity/brain/df9675a4-04c3-472d-8438-6970f311a23e/.user_uploaded/media_1794412683907_1f13109a.pdf';
const buf = fs.readFileSync(pdfPath);
const text = buf.toString('latin1');
// Extract plain text inside parentheses in PDF streams
const matches = text.match(/\(([^\(\)]{3,})\)/g);
if (matches) {
    const extracted = matches.map(m => m.slice(1, -1)).filter(s => /[a-zA-Z]/.test(s));
    console.log('Sample extracted text (first 40 entries):');
    console.log(extracted.slice(0, 40).join(' '));
} else {
    console.log('No direct literal text streams found in PDF.');
}
