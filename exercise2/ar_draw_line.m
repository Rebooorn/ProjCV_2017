function ar_draw_line(P,A,B)
    A_prime = P*A;
    B_prime = P*B;
    plot([A_prime(1)/A_prime(3) B_prime(1)/B_prime(3)],[A_prime(2)/A_prime(3) B_prime(2)/B_prime(3)],'w');
end