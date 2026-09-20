import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '1m', target: 20 },
    { duration: '3m', target: 20 },
    { duration: '1m', target: 0 },
  ],
};

const BASE = __ENV.BASE_URL || 'http://localhost:9898';

export default function () {
  // ~5% of calls hit an error endpoint so the alerts have something to catch
  const path = Math.random() < 0.05 ? '/status/500' : '/';
  const res = http.get(`${BASE}${path}`);
  check(res, { 'status < 500': (r) => r.status < 500 });
  sleep(0.5);
}
