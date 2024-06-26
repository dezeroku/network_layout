#!/usr/bin/env bash

cat >0001-fix-libpfring-sizeof-issue.patch <<'HEREDOC'
--- a/kernel/pf_ring.c
+++ b/kernel/pf_ring.c
@@ -5605,7 +5605,7 @@ static int packet_ring_bind(struct sock
 static int ring_bind(struct socket *sock, struct sockaddr *sa, int addr_len)
 {
   struct sock *sk = sock->sk;
-  char name[sizeof(sa->sa_data)+1];
+  char name[sizeof(sa->sa_data_min)+1];

   debug_printk(2, "ring_bind() called\n");

@@ -5617,7 +5617,7 @@ static int ring_bind(struct socket *sock
   if(sa->sa_family != PF_RING)
     return(-EINVAL);

-  memcpy(name, sa->sa_data, sizeof(sa->sa_data));
+  memcpy(name, sa->sa_data, sizeof(sa->sa_data_min));

   /* Add trailing zero if missing */
   name[sizeof(name)-1] = '\0';
HEREDOC
