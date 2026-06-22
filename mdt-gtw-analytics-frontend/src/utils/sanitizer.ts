import DOMPurify from 'dompurify';

const ALLOWED_HTML_TAGS = ['b', 'i', 'em', 'strong', 'a', 'p', 'br', 'ul', 'li'];
const ALLOWED_HTML_ATTR = ['href', 'title', 'target'];

export const sanitizeHTML = (dirty: string): string => {
  return DOMPurify.sanitize(dirty, {
    ALLOWED_TAGS: ALLOWED_HTML_TAGS,
    ALLOWED_ATTR: ALLOWED_HTML_ATTR,
  });
};

export const sanitizeInput = (input: string): string => {
  if (!input || typeof input !== 'string') return '';
  return input.trim().slice(0, 1000);
};

export const sanitizeURL = (url: string): string => {
  try {
    const parsed = new URL(url);
    if (!['http:', 'https:'].includes(parsed.protocol)) {
      return '';
    }
    return url;
  } catch {
    return '';
  }
};
