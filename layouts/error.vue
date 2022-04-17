<template>
  <div class="container">
    <h1 class="mb-5 mt-5">Error!</h1>

    <div class="mb-3">
      잘못된 접근이거나 예상하지 못한 에러가 발생했습니다.
    </div>

    <div class="mb-5 pb-5">
      정상적인 이용 중 해당 페이지로 이동되었다면 개발자에게 알려 고칠 수 있도록 도와주세요.
    </div>
    
    <div class="row">
      <a class="link col-6" @click="$router.go()">돌아가기</a>
      <a class="link col-6" href="https://twitter.com/blanky_nftdev" target="_blank">신고하기</a>
    </div>

  </div>
</template>