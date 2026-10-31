// TEST STAND-IN for authentication.
// Production: verify the real access token here and set req.user from it.
// Everything else in the server just uses req.user.username.
export function requireUser(req, res, next) {
  const username = req.get('X-Test-User');
  if (!username) {
    return res.status(401).json({ ok: false, error: 'not logged in' });
  }
  req.user = { username };
  next();
}