module.exports = (...allowedRoles) => (req, res, next) => {
    console.log('Role middleware: Checking roles for user:', req.user);
    if (!req.user || !req.user.role || !allowedRoles.includes(req.user.role)) {
        console.log('Role middleware: Access denied, user role:', req.user ?.role, 'required roles:', allowedRoles);
        return res.status(403).json({ message: `Access denied: Requires one of the following roles: ${allowedRoles.join(', ')}` });
    }
    console.log('Role middleware: Access granted, user role:', req.user.role);
    next();
};