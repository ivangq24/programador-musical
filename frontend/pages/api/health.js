// Health check endpoint for Next.js frontend

export default function handler(req, res) {
  if (req.method === 'GET') {
    try {
      // Basic health check - can be extended to check backend connectivity
      res.status(200).json({
        status: 'healthy',
        message: 'Frontend service operational',
        timestamp: new Date().toISOString(),
        version: process.env.npm_package_version || '1.0.0'
      });
    } catch (error) {
      res.status(503).json({
        status: 'unhealthy',
        message: 'Frontend service degraded',
        error: error.message,
        timestamp: new Date().toISOString()
      });
    }
  } else {
    res.setHeader('Allow', ['GET']);
    res.status(405).end(`Method ${req.method} Not Allowed`);
  }
}