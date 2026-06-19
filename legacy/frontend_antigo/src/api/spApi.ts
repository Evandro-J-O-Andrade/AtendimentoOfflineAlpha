import api from '@/apps/operacional/services/api';

const spApi = {
  call: api.post.bind(api),
};

export default spApi;