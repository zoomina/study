-- ������� SQL 3

1. ������ �⺻ ������ id, �̸�, ��, ���ϰ� �Բ�
   ������ �ּ� address, district, postal_code, phone ��ȣ�� �Բ�
   
select c.customer_id, c.first_name, c.last_name, c.email,
	   a.address, a.district, a.postal_code, a.phone
from customer c 
	join address a on c.address_id = a.address_id 

	
2. ������ �⺻ ������ ���� id, �̸�, ��, �̸��ϰ� �Բ�
   ������ �ּ� address, district, postal_code, phone, city�� �Բ�
  
select c.customer_id , c.last_name , c.first_name , c.email ,
	   a.address , a.district , a.postal_code , a.phone , ct.city 
from customer c 
	join address a on c.address_id = a.address_id 
	join city ct on a.city_id = ct.city_id 

	
3. Lima City�� ��� ������ �̸�, ��, �̸���, phonenumber

select c.last_name , c.first_name , c.email , a.phone 
from customer c 
	join address a on c.address_id = a.address_id 
	join city ct on ct.city_id = a.city_id 
where ct.city = 'Lima'


4. rental ������ �߰��� ������ �̸�, ������ �̸�
- ������ �̸�, ������ �̸��� �̸��� ���� fullname �÷����� ���� 2���� �÷�����

select
	r.*,
	c.first_name || ' ' || c.last_name as customer_name,
	s.first_name || ' ' || s.last_name as staff_name
from rental r 
	join customer c on r.customer_id = c.customer_id 
	join staff s on r.staff_id = s.staff_id 
		
10. country�� china�� �ƴ� ������ ���, ������ �̸�(first_name, last_name),
    email, phonenumber, country, city
  
select 
	c.first_name || ' ' || c.last_name as customer_fullname,
	c.email , a.phone , con.country , ct.city 
from customer c 
	join address a   on c.address_id = a.address_id 
	join city ct     on a.city_id = ct.city_id 
	join country con on ct.country_id = con.country_id 
where con.country not in ('China')


12. Music �帣�̸鼭, ��ȭ���̰� 60~180�� ���� ��ȭ�� title, description, length

select 
	f.title , f.description , f.length 
from film f 
	join film_category fc on f.film_id = fc.film_id 
	join category c 	  on fc.category_id = c.category_id 
where 
	c."name" in ('Music') and
	f.length between 60 and 180


13. actor ���̺��� �̿��Ͽ� ����� ID, �̸�, �� �÷���
    �߰��� Angels Life ��ȭ�� ���� ���θ� Y/N���� �÷� �߰�(angelslife_flag)

select a.actor_id , a.first_name , a.last_name ,
	   case when angels_actor.actor_id is null then 'N'
	   		else 'Y'
	   		end as angelslife_flag
from actor a 
	left outer join(
		select f.film_id, f.title, fa.actor_id 
		from film f 
			join film_actor fa on f.film_id = fa.film_id 
		where f.title = 'Angels Life'
	) as angels_actor on a.actor_id = angels_actor.actor_id
    
14. �뿩 ���ڰ� 2005-06-01~14�� �ش��ϴ� �ֹ� �߿��� ������ �̸� = Mike Hillyer �̰ų�
    ������ �̸� = Gloria Cook�� �ش��ϴ� rental�� ��� ����
    - ���� �̸��� ���� �̸��� fullname���� �����ؼ� �߰�

select r.*,
	   c.first_name || ' ' || c.last_name as customer_name,
	   s.first_name || ' ' || s.last_name as staff_name
from rental r 
	join customer c on r.customer_id = c.customer_id 
	join staff s 	on r.staff_id = s.staff_id 
where date(r.rental_date) between '2005-06-01' and '2005-06-14'
	and (s.first_name || ' ' || s.last_name = 'Mike Hillyer' 
	or c.first_name || ' ' || c.last_name = 'Gloria Cook')
	
	
	
-- ������� SQL 4

2. ��ȭ���(rating) ���� ��ȭ(film)�� �� �� ������ �ִ��� Ȯ��

select  rating,
		count(film_id) as num_film
from film
group by rating
;

4. ��ȭ ���(actor)���� �⿬�� ��ȭ�� �� �� ��
   - ����� �̸�, ��, ��ȭ ��

select  a.first_name , a.last_name,
		count(distinct f.film_id) as num_film
from film f 
	join film_actor fa  on f.film_id = fa.film_id 
	join actor a 		on fa.actor_id = a.actor_id 
group by a.actor_id 
;

5. ����(country)�� ����(customer) ��

select con.country ,
		count(c.customer_id) as num_customer
from customer c 
	join address a   on c.address_id = a.address_id 
	join city ct 	 on a.city_id = ct.city_id 
	join country con on ct.country_id = con.country_id 
group by con.country_id 
order by count(c.customer_id) desc
;

8. rental �������� 2005�� 5�� 26�Ͽ� �뿩�� ���� ��, �Ϸ翡 2�� �̻� �뿩�� ������ id

select  c.customer_id,
		count(distinct rental_id) as cnt
from rental r 
	join customer c on r.customer_id = c.customer_id 
where date(r.rental_date) = '2005-05-26'
group by c.customer_id 
having count(distinct rental_id) >= 2
;

9. film_actor ��������, �⿬�� ��ȭ�� ���� ���� ��� 5���� actor_id, ��ȭ ��

select fa.actor_id ,
	   count(film_id) as num_film
from film_actor fa 
	join actor a on fa.actor_id = a.actor_id 
group by fa.actor_id 
order by num_film desc
limit 5
;

13. ���� ��޺� ���� �� Ȯ��
    �뿩 �ݾ׺� ���� ��� ���� (�Ҽ����� �ݿø�)
	A >= 151
	101 <= B <= 150
	51 <= c <= 100
	D <= 50
	
select db.customer_rank, count(db.customer_id) as cnt
from (
	select customer_id ,
		case when round(sum(amount)) >= 151 then 'A'
			 when round(sum(amount)) between 101 and 150 then 'B'
			 when round(sum(amount)) between 51  and 100 then 'C'
			 when round(sum(amount)) <= 50 then 'D'
		 else 'Empty'
		 end as customer_rank
	from payment p 
	group by customer_id 
) as db
group by db.customer_rank
order by db.customer_rank
;


-- ������� SQL 5

1. 180�� �̻� ������ ��ȭ�� �⿬�ϰų� rating�� R�� ��ȭ�� �⿬�� ��ȭ ��쿡 ���ؼ�
   ��� id�� flag �÷� ���
   1) film_actor, film �̿�
   2) union, unionall, intersect, except �� ��Ȳ�� �°� ���
   3) actor_id�� ������ flag ������ ������ �ʵ���

   -- �� �ߺ����Ű� �ȵ���?
select actor_id, 'upper_180min' as flag
	from film_actor fa 
		join film f on fa.film_id = f.film_id 
	where f.length >= 180
union 
select actor_id, 'rating_R' as flag
	from film_actor fa
		join film f on fa.film_id = f.film_id 
	where f.rating = 'R'
;

4. ī�װ����� action, Animation, Horror�� �ش����� �ʴ� �ʸ� ���̵�
	- category ���
	
select f.film_id
from film f
except 
select f.film_id
from category c 
	join film_category fc on c.category_id = fc.category_id 
	join film f 		  on fc.film_id = f.film_id 
where name in ('Action', 'Animation', 'Horror')
;
	
5. staff�� id, �̸�, �� / customer�� id, �̸� �� �� ���� �����͸� �ϳ��� �����ͼ�����
	- �÷� ���� : id, �̸�, ��, flag(����/����)
	
select staff_id as id, first_name, last_name , 'staff' as flag
from staff s 
union
select customer_id as id, first_name , last_name , 'customer' as flag
from customer c 
;
	
6. ������ ������ �̸��� ������ ����� �̸��� ��

select c.first_name , c.last_name 
from (
	select last_name 
	from staff s 
	intersect
	select last_name 
	from customer c 
) as intersected
	join customer c on c.last_name = intersected.last_name
;

8. ����(country)�� ����(city)�� �����, ���� ����� �Ұ�, ��ü �����

-- ������ ���ú� �����
select con.country , ct.city , sum(amount) as sales
from payment p 
	join customer c  on p.customer_id = c.customer_id 
	join address a   on c.address_id = a.address_id 
	join city ct	 on a.city_id = ct.city_id 
	join country con on ct.country_id = con.country_id 
group by con.country , ct.city 

-- ���� ����� �Ұ�
select con.country, sum(amount) as sales
from payment p 
	join customer c  on p.customer_id = c.customer_id 
	join address a   on c.address_id = a.address_id 
	join city ct	 on a.city_id = ct.city_id 
	join country con on ct.country_id = con.country_id 
group by con.country 

-- ��ü �����
select sum(amount) as sales
from payment p 