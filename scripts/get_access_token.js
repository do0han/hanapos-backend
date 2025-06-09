const { createClient } = require('@supabase/supabase-js');

// 여기에 본인 프로젝트 URL/anon key, 테스트 유저 이메일/비번 입력
const SUPABASE_URL = 'https://<project>.supabase.co';
const SUPABASE_ANON_KEY = '<anon_key>';
const EMAIL = '<mickyyoondoo@gmail.com>';
const PASSWORD = '<your_password>';

const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

(async () => {
  const { data, error } = await supabase.auth.signInWithPassword({
    email: EMAIL,
    password: PASSWORD,
  });
  if (error) {
    console.error('로그인 실패:', error.message);
    process.exit(1);
  }
  console.log('access_token:', data.session.access_token);
})(); 